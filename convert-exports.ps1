#!/usr/bin/env pwsh

# Convert Claude.ai exports to markdown with YAML frontmatter

function New-MarkdownFile {
    param(
        [string]$Title,
        [string]$Content,
        [string]$OutputPath,
        [string]$Source,
        [string]$Date,
        [string]$Topic
    )

    $filename = $Title -replace '[<>:"/\\|?*]', '-' -replace '\s+', '-' -replace '-+', '-' -replace '-$', ''
    $filename = "$filename.md"
    $filepath = Join-Path $OutputPath $filename

    $frontmatter = @"
---
title: $Title
source: $Source
date: $Date
topic: $Topic
---

"@

    $fullContent = $frontmatter + $Content
    Set-Content -Path $filepath -Value $fullContent -Encoding UTF8
    Write-Host "[+] Created: $filename"
}

function ConvertConversations {
    Write-Host "`n=== Converting conversations.json ===" -ForegroundColor Cyan

    $jsonPath = "raw/claude-exports/conversations.json"
    $outputPath = "raw/claude-exports"

    try {
        $conversations = Get-Content $jsonPath -Raw | ConvertFrom-Json

        foreach ($conv in $conversations) {
            $title = $conv.name
            $createdAt = $conv.created_at
            $date = [datetime]::Parse($createdAt).ToString("dd-MM-yyyy")

            $content = ""
            if ($conv.summary) {
                $content += "## Summary`n`n$($conv.summary)`n`n"
            }

            $content += "## Messages`n`n"

            foreach ($msg in $conv.chat_messages) {
                $sender = if ($msg.sender -eq "human") { "You" } else { "Claude" }
                $timestamp = [datetime]::Parse($msg.created_at).ToString("HH:mm:ss")

                $text = if ($msg.text) { $msg.text } else { $msg.content[0].text }

                $content += "**$sender** ($timestamp):`n`n$text`n`n"
            }

            New-MarkdownFile -Title $title -Content $content -OutputPath $outputPath -Source "conversations.json" -Date $date -Topic "Conversation"
        }
    }
    catch {
        Write-Host "Error processing conversations.json: $_" -ForegroundColor Red
    }
}

function ConvertDesignChats {
    Write-Host "`n=== Converting design_chats ===" -ForegroundColor Cyan

    $chatFiles = Get-ChildItem "raw/claude-exports/design_chats" -Filter "*.json"
    $outputPath = "raw/claude-exports/design_chats"

    foreach ($file in $chatFiles) {
        try {
            $chat = Get-Content $file.FullName -Raw | ConvertFrom-Json

            $title = $chat.title
            if ($chat.project) {
                $title = "$($chat.project.name) - $title"
            }

            $createdAt = $chat.created_at
            $date = [datetime]::Parse($createdAt).ToString("dd-MM-yyyy")

            $content = ""
            if ($chat.project) {
                $content += "**Project:** $($chat.project.name)`n`n"
            }

            $content += "## Messages`n`n"

            foreach ($msg in $chat.messages) {
                $role = if ($msg.role -eq "user") { "You" } else { "Claude" }
                $timestamp = if ($msg.created_at) { [datetime]::Parse($msg.created_at).ToString("HH:mm:ss") } else { "N/A" }

                $msgContent = ""
                if ($msg.content.text) {
                    $msgContent = $msg.content.text
                }
                elseif ($msg.content -is [string]) {
                    $msgContent = $msg.content
                }
                else {
                    $msgContent = $msg.content | ConvertTo-Json -Depth 2
                }

                $content += "**$role** ($timestamp):`n`n$msgContent`n`n"
            }

            New-MarkdownFile -Title $title -Content $content -OutputPath $outputPath -Source "design_chats" -Date $date -Topic "Design Chat"
        }
        catch {
            Write-Host "Error processing $($file.Name): $_" -ForegroundColor Red
        }
    }
}

function ConvertProjects {
    Write-Host "`n=== Converting projects ===" -ForegroundColor Cyan

    $projectFiles = Get-ChildItem "raw/claude-exports/projects" -Filter "*.json"
    $outputPath = "raw/claude-exports/projects"

    foreach ($file in $projectFiles) {
        try {
            $project = Get-Content $file.FullName -Raw | ConvertFrom-Json

            $title = $project.name
            $createdAt = $project.created_at
            $date = [datetime]::Parse($createdAt).ToString("dd-MM-yyyy")

            $content = ""
            $content += "**Description:**`n`n$($project.description)`n`n"

            if ($project.creator) {
                $content += "**Creator:** $($project.creator.full_name)`n`n"
            }

            $content += "**Private:** $($project.is_private)`n`n"

            if ($project.docs -and $project.docs.Count -gt 0) {
                $content += "## Docs`n`n"
                foreach ($doc in $project.docs) {
                    $content += "- $doc`n"
                }
                $content += "`n"
            }

            New-MarkdownFile -Title $title -Content $content -OutputPath $outputPath -Source "projects" -Date $date -Topic "Project"
        }
        catch {
            Write-Host "Error processing $($file.Name): $_" -ForegroundColor Red
        }
    }
}

# Run conversions
ConvertConversations
ConvertDesignChats
ConvertProjects

Write-Host "`n[SUCCESS] Conversion complete!" -ForegroundColor Green
