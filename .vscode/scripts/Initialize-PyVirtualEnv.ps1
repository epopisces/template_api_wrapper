# create a virtual environment (will generate 'env' dir)
py -3 -m venv .env

# activate the virtual environment
.\.venv\Scripts\activate

# validate venv python is in use (should point to 'env' dir)
$CurInterpreterLoc = (Get-Command python).Path
Write-Host "The interpreter now in use is located at $CurInterpreterLoc"

# install packages listed in requirements
python -m pip install -r .\requirements.txt