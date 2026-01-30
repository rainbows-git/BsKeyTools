# Superpowers for Cursor - Install Script

$ErrorActionPreference = "Continue"

Write-Host "========================================"
Write-Host "  Superpowers for Cursor - Install"
Write-Host "========================================"
Write-Host ""

# Config paths
$superpowersRepo = "https://github.com/obra/superpowers.git"
$codexDir = Join-Path $env:USERPROFILE ".codex"
$superpowersDir = Join-Path $codexDir "superpowers"
# NOTE: Use ~/.cursor/skills/ (NOT skills-cursor/) for user-defined skills
# skills-cursor/ is reserved for Cursor's internal built-in skills
$cursorSkillsDir = Join-Path $env:USERPROFILE ".cursor\skills"
$cursorRulesDir = Join-Path $env:USERPROFILE ".cursor\rules"

# Step 1: Check Git
Write-Host "[1/5] Checking Git..."
$gitCheck = Get-Command git -ErrorAction SilentlyContinue
if ($null -eq $gitCheck) {
    Write-Host "  [X] Git not installed" -ForegroundColor Red
    exit 1
}
Write-Host "  [OK] Git installed" -ForegroundColor Green

# Step 2: Create directories
Write-Host "[2/5] Creating directories..."
if (-not (Test-Path $codexDir)) { New-Item -ItemType Directory -Path $codexDir -Force | Out-Null }
if (-not (Test-Path $cursorSkillsDir)) { New-Item -ItemType Directory -Path $cursorSkillsDir -Force | Out-Null }
if (-not (Test-Path $cursorRulesDir)) { New-Item -ItemType Directory -Path $cursorRulesDir -Force | Out-Null }
Write-Host "  [OK] Directories ready" -ForegroundColor Green

# Step 3: Clone or update repo
Write-Host "[3/5] Getting Superpowers repo..."
$skillsSourcePath = Join-Path $superpowersDir "skills"

# Check if repo exists and is valid (has skills directory)
$repoValid = (Test-Path $superpowersDir) -and (Test-Path $skillsSourcePath)

if ($repoValid) {
    Write-Host "  [-] Repo exists, updating..."
    Push-Location $superpowersDir
    $pullResult = git pull 2>&1
    $pullExitCode = $LASTEXITCODE
    Pop-Location
    if ($pullExitCode -eq 0) {
        Write-Host "  [OK] Updated" -ForegroundColor Green
    }
    else {
        Write-Host "  [!] Update failed: $pullResult" -ForegroundColor Yellow
    }
}
else {
    # Remove incomplete/corrupted directory if exists
    if (Test-Path $superpowersDir) {
        Write-Host "  [-] Removing incomplete repo..."
        Remove-Item -Path $superpowersDir -Recurse -Force -ErrorAction SilentlyContinue
    }
    
    Write-Host "  [-] Cloning repo..."
    $cloneResult = git clone --depth 1 $superpowersRepo $superpowersDir 2>&1
    $cloneExitCode = $LASTEXITCODE
    
    if ($cloneExitCode -eq 0 -and (Test-Path $skillsSourcePath)) {
        Write-Host "  [OK] Cloned" -ForegroundColor Green
    }
    else {
        Write-Host "  [X] Clone failed: $cloneResult" -ForegroundColor Red
        Write-Host "  Please check network connection and try again."
        Read-Host "Press Enter to exit"
        exit 1
    }
}

# Step 4: Copy skills to Cursor skills directory
# Cursor requires each skill to be a DIRECT subdirectory of ~/.cursor/skills/
# NOT nested like ~/.cursor/skills/superpowers/brainstorming/
# NOTE: Must use actual file copy (NOT Junction links) - Cursor cannot scan Junction links properly
Write-Host "[4/5] Installing skills..."

$skillDirs = Get-ChildItem $skillsSourcePath -Directory -ErrorAction SilentlyContinue
if ($null -eq $skillDirs -or $skillDirs.Count -eq 0) {
    Write-Host "  [X] No skills found in $skillsSourcePath" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

$installedCount = 0
$updatedCount = 0

foreach ($skillDir in $skillDirs) {
    $targetPath = Join-Path $cursorSkillsDir $skillDir.Name
    $skillMdPath = Join-Path $targetPath "SKILL.md"
    $isUpdate = Test-Path $targetPath
    
    # Remove old Junction links or existing directory for clean install/update
    if (Test-Path $targetPath) {
        $item = Get-Item $targetPath -Force
        if ($item.LinkType -eq "Junction") {
            # Remove Junction link
            cmd /c "rmdir `"$targetPath`"" 2>$null
        }
        else {
            # Remove regular directory
            Remove-Item -Path $targetPath -Recurse -Force -ErrorAction SilentlyContinue
        }
    }
    
    # Copy skill directory
    Copy-Item -Path $skillDir.FullName -Destination $targetPath -Recurse -Force
    
    if (Test-Path $skillMdPath) {
        if ($isUpdate) {
            $updatedCount++
        }
        else {
            $installedCount++
        }
    }
}

$totalCount = $installedCount + $updatedCount
Write-Host "  [OK] $totalCount skills ($installedCount new, $updatedCount updated)" -ForegroundColor Green

# Step 5: Create rule file
Write-Host "[5/5] Creating rule file..."
$globalRulePath = Join-Path $cursorRulesDir "superpowers.md"

$ruleContent = @'
# Superpowers for Cursor

<EXTREMELY_IMPORTANT>
You have superpowers. Superpowers are specialized skills for software development.

## Available Skills

Skills are in ~/.cursor/skills/

### Core Skills (MANDATORY)

- **superpowers/using-superpowers** - MANDATORY: How to find and use skills.
- **superpowers/brainstorming** - MANDATORY before ANY creative work.
- **superpowers/systematic-debugging** - MANDATORY when encountering any bug.
- **superpowers/test-driven-development** - MANDATORY when implementing features.

### Planning Skills

- **superpowers/writing-plans** - Write detailed implementation plans.
- **superpowers/executing-plans** - Execute plans in batches.
- **superpowers/subagent-driven-development** - Execute tasks with subagents.

### Code Review Skills

- **superpowers/requesting-code-review** - Pre-review checklist.
- **superpowers/verification-before-completion** - MANDATORY when claiming work is complete.

## How to Use

1. **Automatic**: AI checks and uses relevant skills automatically
2. **Manual**: Reference with @superpowers/skill-name

IF A SKILL APPLIES, YOU MUST USE IT.
</EXTREMELY_IMPORTANT>
'@

Set-Content -Path $globalRulePath -Value $ruleContent -Encoding UTF8
Write-Host "  [OK] Rule file created" -ForegroundColor Green

# Done
Write-Host ""
Write-Host "========================================"
Write-Host "  Install Complete!" -ForegroundColor Green
Write-Host "========================================"
Write-Host ""
Write-Host "Installed:"
Write-Host "  - Repo: $superpowersDir"
Write-Host "  - Skills: $cursorSkillsDir ($totalCount skills)"
Write-Host "  - Rule: $globalRulePath"
Write-Host ""
Write-Host "View skills: Cursor Settings (Ctrl+Shift+J) -> Rules -> Agent Decides"
Write-Host ""
Write-Host "Usage: Restart Cursor, then skills will appear and work automatically"
Write-Host ""
Read-Host "Press Enter to exit"
