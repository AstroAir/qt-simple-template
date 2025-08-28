# Documentation Assets

This directory contains assets used in the project documentation.

## Structure

```
assets/
├── README.md          # This file
├── images/           # Screenshots, diagrams, and images
│   ├── screenshots/  # Application screenshots
│   ├── diagrams/     # Architecture and flow diagrams
│   └── icons/        # Documentation icons and logos
└── diagrams/         # Source files for diagrams
    ├── architecture/ # Architecture diagrams
    ├── workflows/    # Process flow diagrams
    └── uml/         # UML diagrams
```

## Image Guidelines

### Screenshots

- **Format**: PNG for UI screenshots
- **Resolution**: High DPI (2x) for clarity
- **Naming**: Descriptive names (e.g., `main-window-light-theme.png`)
- **Size**: Optimize for web viewing
- **Consistency**: Use consistent window sizes and themes

### Diagrams

- **Format**: SVG for scalable diagrams, PNG for complex images
- **Tools**: Use consistent diagramming tools
- **Style**: Follow project visual style
- **Labels**: Clear, readable labels
- **Colors**: Use accessible color schemes

### Icons

- **Format**: SVG preferred, PNG for complex icons
- **Size**: Multiple sizes (16x16, 32x32, 64x64, 128x128)
- **Style**: Consistent with application design
- **Accessibility**: High contrast, clear at small sizes

## Diagram Sources

### Architecture Diagrams

Source files for architecture diagrams using:

- **PlantUML** - Text-based UML diagrams
- **Mermaid** - Markdown-compatible diagrams
- **Draw.io** - Visual diagram editor
- **Lucidchart** - Professional diagramming

### Workflow Diagrams

Process flow diagrams showing:

- Build processes
- CI/CD workflows
- User workflows
- Development processes

## Usage in Documentation

### Markdown Integration

```markdown
![Screenshot](../assets/images/screenshots/main-window.png)
*Main application window with light theme*
```

### HTML Integration

```html
<img src="../assets/images/diagrams/architecture.svg" 
     alt="Application Architecture" 
     style="max-width: 100%; height: auto;">
```

### Doxygen Integration

```cpp
/**
 * @image html architecture.png "Application Architecture"
 * @image latex architecture.eps "Application Architecture" width=10cm
 */
```

## Asset Management

### File Naming

- Use lowercase with hyphens: `main-window-dark-theme.png`
- Include descriptive context: `build-process-diagram.svg`
- Version when necessary: `architecture-v2.png`

### Organization

- Group by type and purpose
- Use subdirectories for categories
- Keep related assets together
- Maintain consistent structure

### Optimization

- **Images**: Compress for web without quality loss
- **SVGs**: Optimize and minify
- **PNGs**: Use appropriate bit depth
- **File sizes**: Keep reasonable for documentation loading

## Contributing Assets

### Creating Screenshots

1. Use consistent application state
2. Choose appropriate theme (usually light for documentation)
3. Ensure clean, uncluttered interface
4. Capture at high resolution
5. Crop to relevant content
6. Optimize file size

### Creating Diagrams

1. Use project style guidelines
2. Ensure readability at different sizes
3. Include clear labels and legends
4. Use accessible colors
5. Provide source files when possible
6. Export in appropriate formats

### Review Process

1. Check image quality and clarity
2. Verify accessibility (alt text, contrast)
3. Ensure consistency with existing assets
4. Validate file sizes and formats
5. Test in documentation context

## Tools and Resources

### Recommended Tools

- **Screenshots**: Built-in OS tools, Greenshot, LightShot
- **Image editing**: GIMP, Photoshop, Canva
- **Diagrams**: Draw.io, Lucidchart, PlantUML, Mermaid
- **Optimization**: TinyPNG, ImageOptim, SVGO

### Style Resources

- Project color palette
- Typography guidelines
- Icon libraries
- Template files

## Maintenance

### Regular Tasks

- Update screenshots when UI changes
- Refresh diagrams when architecture evolves
- Optimize images for performance
- Check for broken references
- Validate accessibility

### Version Control

- Track changes to important diagrams
- Maintain source files
- Document significant updates
- Archive outdated assets
