# PyPI Upload Guide - EDA Kit Package

Complete step-by-step guide to upload your EDA Kit package to PyPI.

---

## Prerequisites

1. **PyPI Account**: Create an account at [pypi.org](https://pypi.org/account/register/)
2. **TestPyPI Account**: Create an account at [test.pypi.org](https://test.pypi.org/account/register/) (for testing)
3. **Build Tools**: Install required build tools

---

## Step 1: Install Required Tools

```bash
pip install --upgrade pip
pip install --upgrade build twine
```

---

## Step 2: Update setup.py

**IMPORTANT:** Before uploading, you need to update `setup.py` with your information:

1. **Change the package name** (if "auto-eda" is taken, choose another):
   ```python
   name="eda-kit",  # Make sure this is unique on PyPI
   ```

2. **Update author information**:
   ```python
   author="Your Name",
   author_email="your.email@example.com",
   ```

3. **Update URLs** (if you have a GitHub repo):
   ```python
   url="https://github.com/yourusername/auto-eda",
   ```

4. **Check version**:
   ```python
   version="0.1.0",  # Start with 0.1.0 for first release
   ```

---

## Step 3: Prepare Your Package

### 3.1 Clean Up

Remove unnecessary files and directories:

```bash
# Remove test output directories
rm -rf test_eda_output/
rm -rf __pycache__/
rm -rf *.pyc
rm -rf .pytest_cache/
rm -rf *.egg-info/
rm -rf dist/
rm -rf build/
```

### 3.2 Verify Package Structure

Your package should have this structure:
```
datascience_package/
├── eda_kit/
│   ├── __init__.py
│   ├── auto_eda.py
│   ├── eda_analyzer.py
│   ├── missing_value_handler.py
│   └── report_generator.py
├── setup.py
├── README.md
├── LICENSE
├── MANIFEST.in
└── requirements.txt
```

### 3.3 Check Package Name Availability

Before uploading, check if your package name is available:

1. Go to [pypi.org](https://pypi.org)
2. Search for "eda-kit"
3. If it's taken, choose a different name and update `setup.py`

**Alternative names to consider:**
- `autoeda`
- `automatic-eda`
- `auto-exploratory-data-analysis`
- `smart-eda`
- `eda-automation`

---

## Step 4: Build Your Package

### 4.1 Clean Previous Builds

```bash
cd /Users/charlie/Downloads/personal/datascience_package
rm -rf dist/ build/ *.egg-info
```

### 4.2 Build Distribution Files

```bash
python -m build
```

This creates:
- `dist/eda_kit-0.1.0.tar.gz` (source distribution)
- `dist/eda_kit-0.1.0-py3-none-any.whl` (wheel distribution)

### 4.3 Verify Build

```bash
# Check what was created
ls -la dist/

# Verify the package
twine check dist/*
```

---

## Step 5: Test on TestPyPI First (Recommended)

**Always test on TestPyPI before uploading to real PyPI!**

### 5.1 Upload to TestPyPI

```bash
twine upload --repository testpypi dist/*
```

You'll be prompted for:
- **Username**: Your TestPyPI username
- **Password**: Your TestPyPI password (or API token)

### 5.2 Install from TestPyPI

Test that your package installs correctly:

```bash
pip install --index-url https://test.pypi.org/simple/ --extra-index-url https://pypi.org/simple/ eda-kit
```

### 5.3 Test the Installation

```python
from eda_kit import AutoEDA
import pandas as pd

# Test it works
df = pd.DataFrame({'a': [1, 2, 3], 'b': [4, 5, 6]})
eda = AutoEDA(df=df)
print("✓ Package installed and working!")
```

---

## Step 6: Upload to Real PyPI

Once you've tested on TestPyPI and everything works:

### 6.1 Upload to PyPI

```bash
twine upload dist/*
```

You'll be prompted for:
- **Username**: Your PyPI username
- **Password**: Your PyPI password (or API token)

### 6.2 Using API Token (Recommended)

Instead of password, use an API token:

1. Go to [pypi.org/manage/account/](https://pypi.org/manage/account/)
2. Scroll to "API tokens"
3. Click "Add API token"
4. Create a token with scope "Entire account" or specific project
5. Use the token as password when uploading

**Example:**
```bash
twine upload dist/*
# Username: __token__
# Password: pypi-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

---

## Step 7: Verify Upload

### 7.1 Check on PyPI Website

1. Go to [pypi.org/project/eda-kit/](https://pypi.org/project/eda-kit/)
2. Verify your package appears correctly
3. Check README renders properly

### 7.2 Install and Test

```bash
# Uninstall any local version first
pip uninstall eda-kit -y

# Install from PyPI
pip install eda-kit

# Test it
python -c "from eda_kit import AutoEDA; print('✓ Success!')"
```

---

## Step 8: Updating Your Package

When you want to release a new version:

### 8.1 Update Version

In `setup.py`:
```python
version="0.1.1",  # Increment version number
```

### 8.2 Rebuild and Upload

```bash
# Clean old builds
rm -rf dist/ build/ *.egg-info

# Build new version
python -m build

# Upload
twine upload dist/*
```

---

## Common Issues and Solutions

### Issue 1: Package Name Already Taken

**Solution:** Choose a different name in `setup.py`:
```python
name="eda-kit-analysis",  # or another unique name
```

### Issue 2: Authentication Failed

**Solution:** 
- Use API token instead of password
- Make sure you're using the correct username
- For TestPyPI, use `--repository testpypi` flag

### Issue 3: README Not Rendering

**Solution:**
- Make sure README.md exists
- Check it's valid Markdown
- Verify `long_description_content_type="text/markdown"` in setup.py

### Issue 4: Import Errors After Installation

**Solution:**
- Check `__init__.py` exports are correct
- Verify package structure
- Test locally first: `pip install -e .`

### Issue 5: Missing Dependencies

**Solution:**
- Check `install_requires` in setup.py
- Verify all dependencies are listed
- Test installation in clean environment

---

## Quick Command Reference

```bash
# 1. Install build tools
pip install --upgrade build twine

# 2. Clean previous builds
rm -rf dist/ build/ *.egg-info

# 3. Build package
python -m build

# 4. Check package
twine check dist/*

# 5. Upload to TestPyPI
twine upload --repository testpypi dist/*

# 6. Test installation from TestPyPI
pip install --index-url https://test.pypi.org/simple/ --extra-index-url https://pypi.org/simple/ eda-kit

# 7. Upload to real PyPI
twine upload dist/*

# 8. Install from PyPI
pip install eda-kit
```

---

## Checklist Before Uploading

- [ ] Updated `setup.py` with your information
- [ ] Package name is available on PyPI
- [ ] README.md is complete and renders correctly
- [ ] LICENSE file exists
- [ ] All dependencies listed in `install_requires`
- [ ] Tested package locally (`pip install -e .`)
- [ ] Removed test files and output directories
- [ ] Built package successfully (`python -m build`)
- [ ] Checked package (`twine check dist/*`)
- [ ] Tested on TestPyPI first
- [ ] Ready to upload to real PyPI

---

## After Uploading

1. **Share your package**: Tell others they can install with `pip install eda-kit`
2. **Update documentation**: Add PyPI installation instructions to README
3. **Monitor**: Check PyPI stats and user feedback
4. **Maintain**: Fix bugs and release updates

---

## Example: Complete Upload Process

```bash
# Navigate to package directory
cd /Users/charlie/Downloads/personal/datascience_package

# 1. Clean up
rm -rf dist/ build/ *.egg-info test_eda_output/ __pycache__/

# 2. Install build tools
pip install --upgrade build twine

# 3. Build
python -m build

# 4. Check
twine check dist/*

# 5. Upload to TestPyPI (test first!)
twine upload --repository testpypi dist/*
# Enter: __token__ as username
# Enter: your-testpypi-token as password

# 6. Test installation
pip install --index-url https://test.pypi.org/simple/ --extra-index-url https://pypi.org/simple/ eda-kit

# 7. If test works, upload to real PyPI
twine upload dist/*
# Enter: __token__ as username
# Enter: your-pypi-token as password

# 8. Verify
pip install eda-kit
python -c "from eda_kit import AutoEDA; print('Success!')"
```

---

## Security Best Practices

1. **Use API Tokens**: Never use your password, use API tokens
2. **Scope Tokens**: Create project-specific tokens when possible
3. **Test First**: Always test on TestPyPI before real PyPI
4. **Version Control**: Use version control (Git) for your code
5. **Don't Commit Secrets**: Never commit API tokens or passwords

---

## Additional Resources

- [PyPI Documentation](https://packaging.python.org/en/latest/)
- [Twine Documentation](https://twine.readthedocs.io/)
- [Python Packaging Guide](https://packaging.python.org/tutorials/packaging-projects/)
- [PyPI Help](https://pypi.org/help/)

---

Good luck with your PyPI upload! 🚀

