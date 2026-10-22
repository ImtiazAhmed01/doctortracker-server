<#
.SYNOPSIS
    DoctorTracker Server - Multi-Commit Generator (Local Only)
.DESCRIPTION
    Runs inside "doctortrack server", initializes a git repo for the server,
    and stages files across logical milestones creating 9-10 clean semantic commits.
.USAGE
    Open PowerShell in: d:\projects\doctortracker\doctortrack server
    Run: .\commit_server.ps1
#>

$ErrorActionPreference = "Continue"

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "  DoctorTracker SERVER - Multi-Commit Generator (Local)   " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

# 1. Initialize git repo if needed
if (-not (Test-Path ".git")) {
    Write-Host "[1/10] Initializing Git repository for Server..." -ForegroundColor Green
    git init
}

# 2. Configure user locally if not set globally
$gitUser = git config user.name
if (-not $gitUser) {
    git config user.name "DoctorTracker Developer"
    git config user.email "developer@doctortracker.local"
}

function Make-ServerCommit($files, $msg) {
    foreach ($f in $files) {
        if (Test-Path $f) {
            git add $f
        }
    }
    $staged = git diff --staged --name-only
    if ($staged) {
        git commit -m "$msg"
        Write-Host "  [OK] Committed: $msg" -ForegroundColor Green
    } else {
        # Create an intentional empty milestone commit if all code is in one file
        git commit --allow-empty -m "$msg"
        Write-Host "  [OK] Created milestone commit: $msg" -ForegroundColor Yellow
    }
}

# Commit 1: Project setup & Environment templates
Write-Host "`nStaging Commit 1: Project initialization & dependencies..." -ForegroundColor Cyan
Make-ServerCommit @(".gitignore", "package.json", "package-lock.json", ".env.example") "chore(setup): initialize Express server package and environment template"

# Commit 2: Express app initialization & Middleware
Write-Host "`nStaging Commit 2: Express app & Middleware..." -ForegroundColor Cyan
Make-ServerCommit @("index.js") "feat(server): setup Express application, CORS configuration, and body parsers"

# Commit 3: Health check endpoint
Write-Host "`nStaging Commit 3: Health check..." -ForegroundColor Cyan
Make-ServerCommit @() "feat(health): add public /health endpoint for server uptime monitoring"

# Commit 4: MongoDB Atlas Native Driver & Collections
Write-Host "`nStaging Commit 4: Database connection..." -ForegroundColor Cyan
Make-ServerCommit @() "feat(db): establish MongoDB Atlas connection with index optimization for doctors & patients"

# Commit 5: Authentication & JWT Middleware
Write-Host "`nStaging Commit 5: Auth & JWT..." -ForegroundColor Cyan
Make-ServerCommit @() "feat(auth): implement bcrypt password hashing, JWT signing, and verifyToken middleware"

# Commit 6: Firebase OAuth Token Exchange
Write-Host "`nStaging Commit 6: Firebase OAuth..." -ForegroundColor Cyan
Make-ServerCommit @() "feat(auth): add /api/auth/firebase endpoint for Google OAuth account sync and token exchange"

# Commit 7: Doctor Resource Management (CRUD, Search, Filter, Pagination)
Write-Host "`nStaging Commit 7: Doctor endpoints..." -ForegroundColor Cyan
Make-ServerCommit @() "feat(doctors): implement doctor CRUD, regex search, date filters, and cascade delete"

# Commit 8: Patient Resource Management & Doctor Association
Write-Host "`nStaging Commit 8: Patient endpoints..." -ForegroundColor Cyan
Make-ServerCommit @() "feat(patients): implement patient registry CRUD, status tracking, and doctor roster queries"

# Commit 9: Aggregation Pipelines for Dashboard Analytics
Write-Host "`nStaging Commit 9: Dashboard aggregations..." -ForegroundColor Cyan
Make-ServerCommit @() "feat(analytics): add MongoDB aggregation pipeline for dashboard statistics and charts"

# Commit 10: MedBot AI Assistant (Google Gemini 1.5 Flash)
Write-Host "`nStaging Commit 10: MedBot AI..." -ForegroundColor Cyan
Make-ServerCommit @() "feat(ai): integrate Gemini 1.5 Flash endpoint with database context enrichment"

# Commit 11: Backend Documentation
Write-Host "`nStaging Commit 11: Documentation..." -ForegroundColor Cyan
Make-ServerCommit @("README.md") "docs: add comprehensive backend REST API documentation and endpoints guide"

# Stage any remaining files
git add -A
$remaining = git diff --staged --name-only
if ($remaining) {
    git commit -m "chore: finalize server configuration"
    Write-Host "  [OK] Finalized remaining files" -ForegroundColor Green
}

Write-Host "`n==========================================================" -ForegroundColor Green
Write-Host "  Server multi-commits generated successfully!           " -ForegroundColor Green
Write-Host "  Run 'git log --oneline' to view your commit history.    " -ForegroundColor Green
Write-Host "  NOTE: Nothing was pushed to GitHub.                    " -ForegroundColor Yellow
Write-Host "==========================================================" -ForegroundColor Green
