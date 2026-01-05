# 🎨 ARTEPIX Design System - Liquid Glass

> **Konsep Utama:** Glassmorphism dengan nuansa "Liquid" yang modern, elegan, dan premium.
> **Inspirasi:** Apple iOS 18, Pacdora.com, Packify.ai

---

## 🎨 Color Palette

### Primary Colors
```css
/* Deep Purple Gradient */
--primary-start: #6B4CE6;
--primary-end: #9B6DFF;

/* Coral/Orange Accent */
--accent-start: #FF6B6B;
--accent-end: #FFB88C;

/* Success, Warning, Error */
--success: #4ADE80;
--warning: #FBBF24;
--error: #EF4444;
```

### Glass Colors
```css
/* Light Mode Glass */
--glass-light: rgba(255, 255, 255, 0.25);
--glass-light-border: rgba(255, 255, 255, 0.4);

/* Dark Mode Glass */
--glass-dark: rgba(30, 30, 40, 0.6);
--glass-dark-border: rgba(255, 255, 255, 0.1);
```

### Background Gradients
```css
/* Light Mode Background */
background: linear-gradient(135deg, #E8E0FF 0%, #FFE5E5 50%, #E0F4FF 100%);

/* Dark Mode Background */
background: linear-gradient(135deg, #1A1625 0%, #2D1B36 50%, #161B2E 100%);
```

---

## 📝 Typography

### Font Family
- **Primary:** `Inter` (Google Fonts)
- **Display/Headers:** `Outfit` (Google Fonts)
- **Fallback:** `-apple-system, BlinkMacSystemFont, sans-serif`

### Font Sizes
| Name | Size | Weight | Usage |
|------|------|--------|-------|
| Display | 32px | 700 | Hero sections |
| H1 | 28px | 700 | Screen titles |
| H2 | 24px | 600 | Section headers |
| H3 | 20px | 600 | Card titles |
| Body Large | 18px | 400 | Primary content |
| Body | 16px | 400 | Standard text |
| Body Small | 14px | 400 | Secondary text |
| Caption | 12px | 500 | Labels, hints |

---

## 🪟 Glassmorphism Specs

### Glass Container
```dart
// Flutter Implementation
Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Colors.white.withOpacity(0.25),
        Colors.white.withOpacity(0.1),
      ],
    ),
    borderRadius: BorderRadius.circular(24),
    border: Border.all(
      color: Colors.white.withOpacity(0.3),
      width: 1.5,
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 20,
        offset: Offset(0, 10),
      ),
    ],
  ),
  child: ClipRRect(
    borderRadius: BorderRadius.circular(24),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
      child: content,
    ),
  ),
)
```

### Glass Button
- **Blur:** 10-15px
- **Opacity:** 0.15-0.25
- **Border:** 1px white/0.3
- **Hover:** Opacity meningkat ke 0.35
- **Press:** Scale down 0.98

### Glass Navigation Bar
- **Height:** 80px (dengan padding bottom untuk safe area)
- **Blur:** 25px
- **Background:** white/0.2 (light) atau black/0.4 (dark)
- **Border Top:** 1px white/0.2
- **Active Indicator:** Gradient pill dengan glow effect

---

## ✨ Animation Guidelines

### Transition Durations
| Type | Duration | Curve |
|------|----------|-------|
| Micro | 150ms | easeOut |
| Standard | 300ms | easeInOut |
| Emphasis | 500ms | easeInOutCubic |
| Page | 400ms | easeInOutCubic |

### Liquid Animations
```dart
// Fluid blob animation untuk background
AnimationController(
  duration: Duration(seconds: 8),
  vsync: this,
)..repeat(reverse: true);

// Transform dengan noise-like movement
Transform.translate(
  offset: Offset(
    sin(animation.value * 2 * pi) * 50,
    cos(animation.value * 2 * pi) * 30,
  ),
  child: blob,
)
```

### Micro-interactions
- **Button Press:** Scale 0.98, +10% opacity, 150ms
- **Card Hover:** Translatey -4px, shadow expand, 200ms
- **Tab Switch:** Slide + fade, 300ms
- **Modal Open:** Slide up + backdrop blur, 400ms

---

## 📦 Component Library

### Smart Chip
Untuk AI onboarding flow, pilihan cepat tanpa typing.

```
┌────────────────┐
│  🍽️ F&B        │  ← Icon + Label
└────────────────┘
   ↓ Selected
┌────────────────┐
│ ✓ 🍽️ F&B      │  ← Gradient border + check
└────────────────┘
```

### Dimension Input
Input PxLxT untuk custom packaging.

```
┌─────────────────────────────────┐
│  📐 Dimensi Kemasan             │
├─────────────────────────────────┤
│ ┌───────┐ ┌───────┐ ┌───────┐  │
│ │  150  │×│  100  │×│   50  │  │
│ │  mm   │ │  mm   │ │   mm  │  │
│ └───────┘ └───────┘ └───────┘  │
│   Panjang   Lebar    Tinggi    │
└─────────────────────────────────┘
```

### Price Display
Menampilkan harga real-time dengan breakdown.

```
┌─────────────────────────────────┐
│        Harga Per Unit           │
│                                 │
│     Rp 3.500                    │
│     ─────────                   │
│  📦 1000 pcs = Rp 3.500.000     │
│                                 │
│  ⓘ Harga sudah termasuk:       │
│    • Cetak full color           │
│    • Laminasi doff              │
│    • Pisau pond                 │
└─────────────────────────────────┘
```

---

## 📱 Screen Layouts

### Splash Screen
- Full screen gradient background
- Animated blob shapes (liquid effect)
- Centered logo dengan fade-in + scale animation
- Progress indicator subtle di bottom

### Onboarding (Pix Assistant)
- Chat-style layout
- Avatar Pix di kiri atas
- Message bubbles dengan glass effect
- Smart chips di bottom area
- Animated typing indicator

### Home Dashboard
- Status bar: transparent
- Search bar: sticky, glass effect
- Grid menu: 2 kolom, icon + label
- Feed section: horizontal scroll cards
- Bottom navbar: fixed, glass effect

---

## 🌙 Dark Mode

Semua komponen harus support dark mode dengan perubahan:
- Background gradient: lebih gelap
- Glass opacity: dinaikkan untuk kontras
- Text: white/90 untuk primary, white/60 untuk secondary
- Borders: white/10 hingga white/20
- Shadows: lebih subtle, almost invisible

---

## 📋 Implementation Checklist

- [ ] Setup color system di `colors.dart`
- [ ] Setup typography di `typography.dart`
- [ ] Create `GlassContainer` widget
- [ ] Create `GlassButton` widget
- [ ] Create `GlassBottomNavBar` widget
- [ ] Create `SmartChip` widget
- [ ] Create `DimensionInput` widget
- [ ] Create `PriceDisplay` widget
- [ ] Implement liquid blob animation
- [ ] Test semua komponen di light & dark mode
