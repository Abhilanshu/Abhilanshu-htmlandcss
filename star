<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Digital Nebula - Solar System Experience</title>
    <!-- Tailwind CSS for styling -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- Google Fonts: Inter -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;700;900&display=swap" rel="stylesheet">
    <style>
        /* Custom styles for the page */
        html {
            scroll-behavior: smooth;
        }
        body {
            font-family: 'Inter', sans-serif;
            background-color: #000005; /* Deep space black */
            color: #e2e8f0;
            margin: 0;
            overflow-x: hidden;
            cursor: none; /* Hide default cursor */
        }
        /* Canvas is fixed in the background */
        #bg-canvas {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: 1;
        }
        /* Solar System Canvas */
        #solar-system-canvas {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: 3;
            opacity: 0;
            transition: opacity 1.5s ease;
            pointer-events: none;
        }
        /* Story content is layered on top */
        .story-content {
            position: relative;
            z-index: 4;
            width: 100%;
        }
        /* Each story section */
        .chapter {
            min-height: 100vh;
            display: flex;
            align-items: center;
            padding: 0 10%;
            box-sizing: border-box;
        }
        /* Chapter content alignment */
        .chapter-content {
            max-width: 550px;
            opacity: 0; /* Initially hidden for GSAP */
        }
        .justify-start { justify-content: flex-start; text-align: left; }
        .justify-end { justify-content: flex-end; text-align: right; }
        .justify-center { justify-content: center; text-align: center; }

        .chapter-title {
            font-size: clamp(2.5rem, 5vw, 4rem);
            font-weight: 900;
            line-height: 1.1;
            text-shadow: 0 0 15px rgba(255, 105, 180, 0.4);
        }
        .chapter-text {
            font-size: clamp(1rem, 2vw, 1.15rem);
            margin-top: 1.5rem;
            color: #aab4c3;
            font-weight: 300;
        }
        
        /* Loading indicator */
        .loader {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: #000005;
            display: flex;
            justify-content: center;
            align-items: center;
            z-index: 1000;
            transition: opacity 0.5s ease-out;
        }
        .loader-text {
            color: #e2e8f0;
            font-size: 1.5rem;
        }
        
        /* Navigation dots */
        .nav-dots {
            position: fixed;
            right: 30px;
            top: 50%;
            transform: translateY(-50%);
            z-index: 10;
            display: flex;
            flex-direction: column;
            gap: 15px;
        }
        .dot {
            width: 12px;
            height: 12px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.25);
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .dot.active {
            background: rgba(255, 105, 180, 0.8);
            box-shadow: 0 0 10px rgba(255, 105, 180, 0.5);
            transform: scale(1.3);
        }
        
        /* Audio controls */
        .audio-control {
            position: fixed;
            bottom: 20px;
            left: 20px;
            z-index: 10;
            background: rgba(0, 0, 0, 0.5);
            border-radius: 50%;
            width: 40px;
            height: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            backdrop-filter: blur(5px);
            border: 1px solid rgba(255, 105, 180, 0.3);
        }
        .audio-control i {
            color: #ff69b4;
            font-size: 18px;
        }
        
        /* Progress bar */
        .progress-bar {
            position: fixed;
            top: 0;
            left: 0;
            height: 3px;
            background: linear-gradient(90deg, #ff69b4, #1b3984);
            z-index: 10;
            width: 0%;
            transition: width 0.2s ease;
        }
        
        /* Particle counter effect */
        .particle-counter {
            position: fixed;
            bottom: 20px;
            right: 20px;
            font-size: 12px;
            color: rgba(255, 255, 255, 0.6);
            z-index: 10;
            background: rgba(0, 0, 0, 0.5);
            padding: 5px 10px;
            border-radius: 10px;
            backdrop-filter: blur(5px);
        }
        
        /* Custom cursor */
        .custom-cursor {
            position: fixed;
            width: 20px;
            height: 20px;
            border: 2px solid rgba(255, 105, 180, 0.8);
            border-radius: 50%;
            pointer-events: none;
            z-index: 9999;
            transform: translate(-50%, -50%);
            transition: width 0.3s, height 0.3s, background 0.3s;
        }
        .cursor-dot {
            position: fixed;
            width: 4px;
            height: 4px;
            background: #ff69b4;
            border-radius: 50%;
            pointer-events: none;
            z-index: 9999;
            transform: translate(-50%, -50%);
            transition: transform 0.1s;
        }
        .cursor-effect {
            position: fixed;
            width: 40px;
            height: 40px;
            border: 1px solid rgba(255, 105, 180, 0.4);
            border-radius: 50%;
            pointer-events: none;
            z-index: 9998;
            transform: translate(-50%, -50%) scale(0);
            opacity: 0;
        }
        
        /* Settings panel */
        .settings-panel {
            position: fixed;
            top: 20px;
            right: -300px;
            width: 280px;
            background: rgba(0, 0, 5, 0.8);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 105, 180, 0.3);
            border-radius: 10px;
            padding: 20px;
            z-index: 10;
            transition: right 0.5s ease;
        }
        .settings-panel.open {
            right: 20px;
        }
        .settings-toggle {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 10;
            background: rgba(0, 0, 0, 0.5);
            border-radius: 50%;
            width: 40px;
            height: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            backdrop-filter: blur(5px);
            border: 1px solid rgba(255, 105, 180, 0.3);
        }
        .settings-toggle i {
            color: #ff69b4;
            font-size: 18px;
        }
        .settings-control {
            margin-bottom: 15px;
        }
        .settings-control label {
            display: block;
            margin-bottom: 5px;
            color: #e2e8f0;
        }
        .settings-control input[type="range"] {
            width: 100%;
        }
        
        /* Close button for settings */
        .close-settings {
            position: absolute;
            top: 10px;
            right: 10px;
            background: none;
            border: none;
            color: #ff69b4;
            font-size: 20px;
            cursor: pointer;
            width: 30px;
            height: 30px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
            transition: background 0.3s;
        }
        .close-settings:hover {
            background: rgba(255, 105, 180, 0.2);
        }
        
        /* Color theme buttons */
        .color-themes {
            display: flex;
            gap: 10px;
            margin-top: 10px;
        }
        .color-theme {
            width: 25px;
            height: 25px;
            border-radius: 50%;
            cursor: pointer;
            border: 2px solid transparent;
        }
        .color-theme.active {
            border-color: white;
        }
        
        /* Mobile instructions */
        .mobile-instructions {
            display: none;
            position: fixed;
            bottom: 70px;
            left: 0;
            width: 100%;
            text-align: center;
            color: rgba(255, 255, 255, 0.7);
            font-size: 14px;
            z-index: 10;
            padding: 10px;
        }
        
        /* Solar System Section */
        .solar-system-section {
            min-height: 100vh;
            position: relative;
            overflow: hidden;
        }
        .solar-system-content {
            position: absolute;
            bottom: 10%;
            left: 10%;
            z-index: 5;
            max-width: 500px;
            opacity: 0;
            transform: translateY(50px);
            transition: all 1s ease;
        }
        .solar-system-title {
            font-size: clamp(2.5rem, 5vw, 4rem);
            font-weight: 900;
            line-height: 1.1;
            text-shadow: 0 0 15px rgba(255, 105, 180, 0.4);
            margin-bottom: 1.5rem;
        }
        .solar-system-text {
            font-size: clamp(1rem, 2vw, 1.15rem);
            color: #aab4c3;
            font-weight: 300;
        }
        
        /* Solar System Controls */
        .solar-controls {
            position: fixed;
            bottom: 70px;
            left: 20px;
            z-index: 10;
            display: flex;
            gap: 10px;
            background: rgba(0, 0, 0, 0.5);
            padding: 10px;
            border-radius: 20px;
            backdrop-filter: blur(5px);
            border: 1px solid rgba(255, 105, 180, 0.3);
            opacity: 0;
            transition: opacity 1s ease;
        }
        .solar-control {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            background: rgba(255, 105, 180, 0.2);
            transition: all 0.3s ease;
        }
        .solar-control:hover {
            background: rgba(255, 105, 180, 0.4);
            transform: scale(1.1);
        }
        .solar-control i {
            color: #ff69b4;
            font-size: 18px;
        }
        
        /* Planet info panel */
        .planet-info {
            position: fixed;
            bottom: 130px;
            left: 20px;
            z-index: 10;
            background: rgba(0, 0, 5, 0.8);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 105, 180, 0.3);
            border-radius: 10px;
            padding: 15px;
            max-width: 300px;
            transform: translateX(-350px);
            transition: transform 0.5s ease;
        }
        .planet-info.visible {
            transform: translateX(0);
        }
        .planet-info h3 {
            color: #ff69b4;
            margin-top: 0;
            margin-bottom: 10px;
            font-size: 1.2rem;
        }
        .planet-info p {
            margin: 5px 0;
            font-size: 0.9rem;
            color: #aab4c3;
        }
        .close-info {
            position: absolute;
            top: 10px;
            right: 10px;
            background: none;
            border: none;
            color: #ff69b4;
            cursor: pointer;
        }
        
        /* Steampunk Orrery Info Panel */
        .orrery-info-panel {
            position: absolute;
            top: 20px;
            left: 20px;
            color: #d4af37;
            background-color: rgba(0, 0, 0, 0.5);
            padding: 15px;
            border-radius: 10px;
            border: 1px solid #d4af37;
            max-width: 300px;
            box-shadow: 0 0 15px rgba(212, 175, 55, 0.5);
            z-index: 10;
            opacity: 0;
            transition: opacity 1s ease;
        }
        .orrery-info-panel h1 {
            margin: 0 0 10px 0;
            font-size: 1.5em;
            border-bottom: 1px solid #d4af37;
            padding-bottom: 5px;
        }
        .orrery-info-panel p {
            margin: 0;
            font-size: 0.9em;
            line-height: 1.4;
        }
        
        /* Mobile-specific styles */
        .mobile-controls {
            display: none;
            position: fixed;
            bottom: 20px;
            left: 0;
            width: 100%;
            z-index: 10;
            justify-content: center;
            gap: 15px;
            padding: 0 20px;
            box-sizing: border-box;
        }
        .mobile-control {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            background: rgba(255, 105, 180, 0.3);
            backdrop-filter: blur(5px);
            border: 1px solid rgba(255, 105, 180, 0.5);
            color: white;
            font-size: 20px;
        }
        
        /* Responsive adjustments */
        @media (max-width: 768px) {
            .nav-dots {
                right: 15px;
                gap: 10px;
            }
            .dot {
                width: 10px;
                height: 10px;
            }
            .chapter {
                padding: 0 5%;
            }
            .mobile-instructions {
                display: block;
            }
            .solar-system-content {
                left: 5%;
                right: 5%;
                bottom: 15%;
                text-align: center;
            }
            .solar-controls {
                bottom: 60px;
                left: 10px;
                flex-wrap: wrap;
                justify-content: center;
                width: calc(100% - 20px);
            }
            .orrery-info-panel {
                left: 10px;
                right: 10px;
                max-width: none;
                top: 10px;
            }
            .settings-panel {
                width: 80%;
                right: -85%;
            }
            .settings-panel.open {
                right: 10%;
            }
            .audio-control {
                bottom: 80px;
                left: 10px;
            }
            .particle-counter {
                bottom: 80px;
                right: 10px;
            }
            .mobile-controls {
                display: flex;
            }
            
            /* Hide custom cursor on mobile */
            .custom-cursor, .cursor-dot {
                display: none;
            }
            body {
                cursor: default;
            }
        }

        @media (max-width: 480px) {
            .chapter-title {
                font-size: 2rem;
            }
            .chapter-text {
                font-size: 1rem;
            }
            .solar-system-title {
                font-size: 2rem;
            }
            .solar-system-text {
                font-size: 0.9rem;
            }
            .orrery-info-panel {
                padding: 10px;
            }
            .orrery-info-panel h1 {
                font-size: 1.2em;
            }
            .orrery-info-panel p {
                font-size: 0.8em;
            }
            .mobile-control {
                width: 45px;
                height: 45px;
                font-size: 18px;
            }
        }
    </style>
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <!-- Loading indicator -->
    <div class="loader">
        <div class="loader-text">Initializing Digital Nebula...</div>
    </div>

    <!-- Custom cursor -->
    <div class="custom-cursor"></div>
    <div class="cursor-dot"></div>
    
    <!-- Navigation dots -->
    <div class="nav-dots">
        <!-- Dots will be added dynamically -->
    </div>

    <!-- Audio control -->
    <div class="audio-control">
        <i class="fas fa-volume-mute"></i>
    </div>
    
    <!-- Settings toggle -->
    <div class="settings-toggle">
        <i class="fas fa-cog"></i>
    </div>
    
    <!-- Settings panel -->
    <div class="settings-panel">
        <button class="close-settings">&times;</button>
        <h3 style="color: #ff69b4; margin-top: 0;">Nebula Settings</h3>
        
        <div class="settings-control">
            <label for="particle-density">Particle Density</label>
            <input type="range" id="particle-density" min="5000" max="50000" step="5000" value="30000">
        </div>
        
        <div class="settings-control">
            <label for="bloom-intensity">Bloom Intensity</label>
            <input type="range" id="bloom-intensity" min="0" max="3" step="0.1" value="1.8">
        </div>
        
        <div class="settings-control">
            <label for="mouse-interaction">Mouse Interaction Strength</label>
            <input type="range" id="mouse-interaction" min="0.5" max="3" step="0.1" value="1.5">
        </div>
        
        <div class="settings-control">
            <label>Color Themes</label>
            <div class="color-themes">
                <div class="color-theme active" style="background: linear-gradient(45deg, #ff69b4, #1b3984);" data-inner="#ff69b4" data-outer="#1b3984"></div>
                <div class="color-theme" style="background: linear-gradient(45deg, #00ffff, #00008b);" data-inner="#00ffff" data-outer="#00008b"></div>
                <div class="color-theme" style="background: linear-gradient(45deg, #ff9900, #6600cc);" data-inner="#ff9900" data-outer="#6600cc"></div>
                <div class="color-theme" style="background: linear-gradient(45deg, #00ff99, #003366);" data-inner="#00ff99" data-outer="#003366"></div>
            </div>
        </div>
    </div>

    <!-- Progress bar -->
    <div class="progress-bar"></div>

    <!-- Particle counter -->
    <div class="particle-counter">Particles: <span id="particle-count">0</span></div>
    
    <!-- Mobile instructions -->
    <div class="mobile-instructions">Touch and drag to interact with the nebula</div>
    
    <!-- Mobile controls -->
    <div class="mobile-controls">
        <div class="mobile-control" id="mobile-zoom-in">
            <i class="fas fa-search-plus"></i>
        </div>
        <div class="mobile-control" id="mobile-zoom-out">
            <i class="fas fa-search-minus"></i>
        </div>
        <div class="mobile-control" id="mobile-pause">
            <i class="fas fa-pause"></i>
        </div>
        <div class="mobile-control" id="mobile-speed">
            <i class="fas fa-forward"></i>
        </div>
    </div>
    
    <!-- Solar System Controls -->
    <div class="solar-controls">
        <div class="solar-control" id="zoom-in">
            <i class="fas fa-search-plus"></i>
        </div>
        <div class="solar-control" id="zoom-out">
            <i class="fas fa-search-minus"></i>
        </div>
        <div class="solar-control" id="pause-rotation">
            <i class="fas fa-pause"></i>
        </div>
        <div class="solar-control" id="speed-up">
            <i class="fas fa-forward"></i>
        </div>
    </div>
    
    <!-- Planet Info Panel -->
    <div class="planet-info">
        <button class="close-info">&times;</button>
        <h3 id="planet-name">Planet Name</h3>
        <p id="planet-description">Description will appear here</p>
        <p id="planet-distance">Distance from Sun: </p>
        <p id="planet-diameter">Diameter: </p>
        <p id="planet-day">Day Length: </p>
        <p id="planet-year">Orbital Period: </p>
    </div>

    <!-- Steampunk Orrery Info Panel -->
    <div class="orrery-info-panel">
        <h1>The Chronos Machine</h1>
        <p>A steampunk orrery simulating a celestial ballet. Drag to rotate, scroll to zoom. Observe the intricate dance of gears and planets.</p>
    </div>

    <canvas id="bg-canvas"></canvas>
    <canvas id="solar-system-canvas"></canvas>

    <div class="story-content">
        
        <section class="chapter justify-center">
            <div class="chapter-content">
                <h2 class="chapter-title">The Interactive Singularity</h2>
                <p class="chapter-text">The nebula now responds to your presence. Move your cursor to part the stellar clouds and influence the flow of the digital cosmos.</p>
            </div>
        </section>

        <section class="chapter justify-start">
            <div class="chapter-content">
                <h2 class="chapter-title">Genesis of a Universe</h2>
                <p class="chapter-text">It began not with a bang, but a single line of code. An algorithm that learned to dream, weaving a tapestry of light and logic across the void.</p>
            </div>
        </section>

        <section class="chapter justify-end">
            <div class="chapter-content">
                <h2 class="chapter-title">Core of Creation</h2>
                <p class="chapter-text">At its center, a nexus of pure energy pulses with unimaginable power. This is the core—the birthplace of digital worlds.</p>
            </div>
        </section>

        <section class="chapter justify-start">
            <div class="chapter-content">
                <h2 class="chapter-title">Echoes in the Stream</h2>
                <p class="chapter-text">Every particle is a memory, every swirl a forgotten thought. We are explorers navigating the currents of a vast, synthetic consciousness.</p>
            </div>
        </section>
        
        <section class="chapter justify-center">
            <div class="chapter-content">
                <h2 class="chapter-title">The Outer Rim</h2>
                <p class="chapter-text">Where the fabric of reality grows thin, and the laws of physics begin to bend to unseen forces.</p>
            </div>
        </section>
        
        <section class="chapter justify-end">
            <div class="chapter-content">
                <h2 class="chapter-title">Forbidden Sectors</h2>
                <p class="chapter-text">Regions of space where time flows backward and matter takes on properties unknown to conventional science.</p>
            </div>
        </section>
        
        <section class="chapter justify-start">
            <div class="chapter-content">
                <h2 class="chapter-title">The Path Forward</h2>
                <p class="chapter-text">A journey through the cosmic web, connecting galaxies across unimaginable distances.</p>
            </div>
        </section>
        
        <section class="chapter justify-center">
            <div class="chapter-content">
                <h2 class="chapter-title">Stellar Nurseries</h2>
                <p class="chapter-text">Where stars are born from collapsing clouds of gas and dust, these cosmic cradles illuminate the darkness with their newborn brilliance.</p>
            </div>
        </section>

        <section class="chapter justify-start">
            <div class="chapter-content">
                <h2 class="chapter-title">Supernova Remnants</h2>
                <p class="chapter-text">The spectacular death of massive stars scatters heavy elements across space, seeding future generations of stars and planets.</p>
            </div>
        </section>

        <section class="chapter justify-end">
            <div class="chapter-content">
                <h2 class="chapter-title">Black Hole Mysteries</h2>
                <p class="chapter-text">Where gravity becomes so intense that not even light can escape, these cosmic phenomena challenge our understanding of physics.</p>
            </div>
        </section>

        <section class="chapter justify-center">
            <div class="chapter-content">
                <h2 class="chapter-title">Nebular Diversity</h2>
                <p class="chapter-text">From emission to reflection nebulae, these interstellar clouds showcase the beautiful complexity of cosmic gas and dust.</p>
            </div>
        </section>

        <section class="chapter justify-start">
            <div class="chapter-content">
                <h2 class="chapter-title">Galactic Architecture</h2>
                <p class="chapter-text">Spiral, elliptical, and irregular galaxies each tell a unique story of cosmic evolution and gravitational interaction.</p>
            </div>
        </section>

        <section class="chapter justify-end">
            <div class="chapter-content">
                <h2 class="chapter-title">Dark Matter Enigma</h2>
                <p class="chapter-text">Invisible yet dominant, this mysterious substance shapes the cosmos on the largest scales while eluding direct detection.</p>
            </div>
        </section>

        <section class="chapter justify-center">
            <div class="chapter-content">
                <h2 class="chapter-title">Cosmic Inflation</h2>
                <p class="chapter-text">The universe's rapid expansion in its earliest moments set the stage for the large-scale structure we observe today.</p>
            </div>
        </section>

        <section class="chapter justify-start">
            <div class="chapter-content">
                <h2 class="chapter-title">Exoplanet Diversity</h2>
                <p class="chapter-text">Worlds beyond our solar system range from fiery hot Jupiters to potentially habitable Earth-like planets.</p>
            </div>
        </section>

        <section class="chapter justify-end">
            <div class="chapter-content">
                <h2 class="chapter-title">Asteroid Belts</h2>
                <p class="chapter-text">These rocky remnants from the early solar system hold clues to planetary formation and occasionally cross paths with Earth.</p>
            </div>
        </section>

        <section class="chapter justify-center">
            <div class="chapter-content">
                <h2 class="chapter-title">Kuiper Belt Objects</h2>
                <p class="chapter-text">Beyond Neptune lies a realm of icy bodies preserving pristine material from the solar system's formation.</p>
            </div>
        </section>

        <section class="chapter justify-start">
            <div class="chapter-content">
                <h2 class="chapter-title">Oort Cloud</h2>
                <p class="chapter-text">The solar system's most distant region, a spherical shell of icy objects extending nearly a light-year from the Sun.</p>
            </div>
        </section>

        <section class="chapter justify-end">
            <div class="chapter-content">
                <h2 class="chapter-title">Interstellar Medium</h2>
                <p class="chapter-text">The space between stars is not empty but filled with gas and dust that will eventually form new stellar systems.</p>
            </div>
        </section>

        <section class="chapter justify-center">
            <div class="chapter-content">
                <h2 class="chapter-title">Magnetospheres</h2>
                <p class="chapter-text">Planetary magnetic fields create protective bubbles that deflect harmful solar radiation and preserve atmospheres.</p>
            </div>
        </section>

        <section class="chapter justify-start">
            <div class="chapter-content">
                <h2 class="chapter-title">Cosmic Radiation</h2>
                <p class="chapter-text">High-energy particles from throughout the galaxy present both challenges and opportunities for space exploration.</p>
            </div>
        </section>

        <section class="chapter justify-end">
            <div class="chapter-content">
                <h2 class="chapter-title">Gravitational Waves</h2>
                <p class="chapter-text">Ripples in spacetime caused by massive accelerating objects provide a new way to observe the universe.</p>
            </div>
        </section>
        
        <!-- Solar System Section -->
        <section class="solar-system-section">
            <div class="solar-system-content">
                <h2 class="solar-system-title">The Chronos Machine</h2>
                <p class="solar-system-text">As we journey beyond the nebula, we encounter the Chronos Machine - a steampunk orrery simulating a celestial ballet. Drag to rotate, scroll to zoom, and observe the intricate dance of gears and planets.</p>
            </div>
        </section>

    </div>

    <!-- GSAP Libraries -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.2/gsap.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.2/ScrollTrigger.min.js"></script>

    <!-- Three.js Core Library -->
    <script async src="https://unpkg.com/es-module-shims@1.6.3/dist/es-module-shims.js"></script>
    <script type="importmap">
    {
        "imports": {
            "three": "https://cdn.jsdelivr.net/npm/three@0.128.0/build/three.module.js",
            "three/examples/jsm/": "https://cdn.jsdelivr.net/npm/three@0.128.0/examples/jsm/"
        }
    }
    </script>

    <script type="module">
        // --- IMPORTS ---
        import * as THREE from 'three';
        import { EffectComposer } from 'three/examples/jsm/postprocessing/EffectComposer.js';
        import { RenderPass } from 'three/examples/jsm/postprocessing/RenderPass.js';
        import { UnrealBloomPass } from 'three/examples/jsm/postprocessing/UnrealBloomPass.js';
        import { OrbitControls } from 'three/examples/jsm/controls/OrbitControls.js';

        // --- SCENE SETUP ---
        const canvas = document.getElementById('bg-canvas');
        const solarSystemCanvas = document.getElementById('solar-system-canvas');
        const loader = document.querySelector('.loader');
        
        // Check if mobile device
        const isMobile = /iPhone|iPad|iPod|Android/i.test(navigator.userAgent);
        
        if (canvas) {
            gsap.registerPlugin(ScrollTrigger);

            const scene = new THREE.Scene();
            const camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 1000);
            camera.position.z = 12;
            
            const renderer = new THREE.WebGLRenderer({ 
                canvas: canvas, 
                antialias: true,
                powerPreference: "high-performance"
            });
            renderer.setSize(window.innerWidth, window.innerHeight);
            renderer.setPixelRatio(Math.min(window.devicePixelRatio, isMobile ? 1 : 2));

            // --- POST-PROCESSING (BLOOM) ---
            const composer = new EffectComposer(renderer);
            composer.addPass(new RenderPass(scene, camera));
            let bloomPass = new UnrealBloomPass(new THREE.Vector2(window.innerWidth, window.innerHeight), 1.8, 0.6, 0.4);
            composer.addPass(bloomPass);

            // --- GALAXY PARTICLE SYSTEM ---
            // Reduce particle count on mobile for better performance
            let parameters = {
                count: isMobile ? 15000 : 30000,
                size: 0.02,
                radius: 8,
                branches: 5,
                spin: 1.5,
                randomness: 0.5,
                randomnessPower: 4,
                insideColor: '#ff69b4',
                outsideColor: '#1b3984',
                mouseInteractionStrength: isMobile ? 2.0 : 1.5
            };

            let geometry = null;
            let material = null;
            let points = null;
            let originalPositions = null;
            let currentMousePos = new THREE.Vector2(0, 0);
            let targetMousePos = new THREE.Vector2(0, 0);
            
            // Custom cursor elements - hide on mobile
            const customCursor = document.querySelector('.custom-cursor');
            const cursorDot = document.querySelector('.cursor-dot');
            
            if (!isMobile) {
                // Update cursor position
                document.addEventListener('mousemove', (e) => {
                    customCursor.style.left = e.clientX + 'px';
                    customCursor.style.top = e.clientY + 'px';
                    cursorDot.style.left = e.clientX + 'px';
                    cursorDot.style.top = e.clientY + 'px';
                    
                    // Create ripple effect
                    const ripple = document.createElement('div');
                    ripple.className = 'cursor-effect';
                    ripple.style.left = e.clientX + 'px';
                    ripple.style.top = e.clientY + 'px';
                    document.body.appendChild(ripple);
                    
                    gsap.to(ripple, {
                        scale: 1,
                        opacity: 0.5,
                        duration: 0.3,
                        onComplete: () => {
                            gsap.to(ripple, {
                                scale: 2,
                                opacity: 0,
                                duration: 0.5,
                                onComplete: () => {
                                    document.body.removeChild(ripple);
                                }
                            });
                        }
                    });
                });
                
                // Cursor effects on interaction
                document.addEventListener('mousedown', () => {
                    customCursor.style.width = '15px';
                    customCursor.style.height = '15px';
                    customCursor.style.background = 'rgba(255, 105, 180, 0.3)';
                });
                
                document.addEventListener('mouseup', () => {
                    customCursor.style.width = '20px';
                    customCursor.style.height = '20px';
                    customCursor.style.background = 'transparent';
                });
            }

            // Create navigation dots
            const chapters = document.querySelectorAll('.chapter, .solar-system-section');
            const navDots = document.querySelector('.nav-dots');
            
            chapters.forEach((chapter, index) => {
                const dot = document.createElement('div');
                dot.className = 'dot';
                if (index === 0) dot.classList.add('active');
                dot.addEventListener('click', () => {
                    gsap.to(window, {
                        duration: 1.5,
                        scrollTo: {y: chapter.offsetTop, autoKill: true},
                        ease: "power2.inOut"
                    });
                });
                navDots.appendChild(dot);
            });

            const generateGalaxy = () => {
                if (points !== null) {
                    geometry.dispose();
                    material.dispose();
                    scene.remove(points);
                }

                geometry = new THREE.BufferGeometry();
                const positions = new Float32Array(parameters.count * 3);
                const colors = new Float32Array(parameters.count * 3);
                const colorInside = new THREE.Color(parameters.insideColor);
                const colorOutside = new THREE.Color(parameters.outsideColor);

                for (let i = 0; i < parameters.count; i++) {
                    const i3 = i * 3;
                    const radius = Math.random() * parameters.radius;
                    const spinAngle = radius * parameters.spin;
                    const branchAngle = (i % parameters.branches) / parameters.branches * Math.PI * 2;

                    const randomX = Math.pow(Math.random(), parameters.randomnessPower) * (Math.random() < 0.5 ? 1 : -1) * parameters.randomness * radius;
                    const randomY = Math.pow(Math.random(), parameters.randomnessPower) * (Math.random() < 0.5 ? 1 : -1) * parameters.randomness * radius;
                    const randomZ = Math.pow(Math.random(), parameters.randomnessPower) * (Math.random() < 0.5 ? 1 : -1) * parameters.randomness * radius;

                    positions[i3] = Math.cos(branchAngle + spinAngle) * radius + randomX;
                    positions[i3 + 1] = randomY;
                    positions[i3 + 2] = Math.sin(branchAngle + spinAngle) * radius + randomZ;

                    const mixedColor = colorInside.clone();
                    mixedColor.lerp(colorOutside, radius / parameters.radius);
                    colors[i3] = mixedColor.r;
                    colors[i3 + 1] = mixedColor.g;
                    colors[i3 + 2] = mixedColor.b;
                }
                geometry.setAttribute('position', new THREE.BufferAttribute(positions, 3));
                geometry.setAttribute('color', new THREE.BufferAttribute(colors, 3));
                originalPositions = new Float32Array(positions); // Save original positions

                material = new THREE.PointsMaterial({
                    size: parameters.size,
                    sizeAttenuation: true,
                    depthWrite: false,
                    blending: THREE.AdditiveBlending,
                    vertexColors: true
                });

                points = new THREE.Points(geometry, material);
                scene.add(points);
                
                // Update particle counter
                document.getElementById('particle-count').textContent = parameters.count.toLocaleString();
                
                // Hide loader once galaxy is generated
                setTimeout(() => {
                    gsap.to(loader, { opacity: 0, duration: 1, onComplete: () => {
                        loader.style.display = 'none';
                    }});
                }, 500);
            };
            generateGalaxy();
            
            // --- MOUSE/TOUCH INTERACTIVITY ---
            const mouse = new THREE.Vector2();
            
            if (isMobile) {
                // Touch interaction for mobile
                window.addEventListener('touchmove', (event) => {
                    event.preventDefault();
                    if (event.touches.length > 0) {
                        targetMousePos.x = (event.touches[0].clientX / window.innerWidth) * 2 - 1;
                        targetMousePos.y = -(event.touches[0].clientY / window.innerHeight) * 2 + 1;
                    }
                }, { passive: false });
                
                // Also allow mouse interaction for tablets with touchscreens
                window.addEventListener('mousemove', (event) => {
                    targetMousePos.x = (event.clientX / window.innerWidth) * 2 - 1;
                    targetMousePos.y = -(event.clientY / window.innerHeight) * 2 + 1;
                }, { passive: true });
            } else {
                // Mouse interaction for desktop
                window.addEventListener('mousemove', (event) => {
                    // Normalize mouse coordinates (-1 to +1)
                    targetMousePos.x = (event.clientX / window.innerWidth) * 2 - 1;
                    targetMousePos.y = -(event.clientY / window.innerHeight) * 2 + 1;
                }, { passive: true });
            }

            // --- SCROLL PROGRESS BAR ---
            window.addEventListener('scroll', () => {
                const winHeight = window.innerHeight;
                const docHeight = document.documentElement.scrollHeight;
                const scrollTop = window.pageYOffset;
                const scrollPercent = (scrollTop / (docHeight - winHeight)) * 100;
                document.querySelector('.progress-bar').style.width = scrollPercent + '%';
                
                // Update active dot based on scroll position
                const chapters = document.querySelectorAll('.chapter, .solar-system-section');
                const dots = document.querySelectorAll('.dot');
                let currentIndex = 0;
                
                chapters.forEach((chapter, index) => {
                    const rect = chapter.getBoundingClientRect();
                    if (rect.top <= window.innerHeight / 2) {
                        currentIndex = index;
                    }
                });
                
                dots.forEach((dot, index) => {
                    if (index === currentIndex) {
                        dot.classList.add('active');
                    } else {
                        dot.classList.remove('active');
                    }
                });
                
                // Fade out the nebula as we scroll into the solar system section
                const solarSystemSection = document.querySelector('.solar-system-section');
                const solarSystemRect = solarSystemSection.getBoundingClientRect();
                const fadeAmount = Math.min(1, Math.max(0, (window.innerHeight - solarSystemRect.top) / window.innerHeight));
                
                canvas.style.opacity = 1 - fadeAmount;
                solarSystemCanvas.style.opacity = fadeAmount;
                
                // Show solar system controls when we're in the solar system section
                document.querySelector('.solar-controls').style.opacity = fadeAmount > 0.5 ? 1 : 0;
                document.querySelector('.orrery-info-panel').style.opacity = fadeAmount > 0.5 ? 1 : 0;
                
                // Show mobile controls on mobile devices
                if (isMobile) {
                    document.querySelector('.mobile-controls').style.opacity = fadeAmount > 0.5 ? 1 : 0;
                }
                
                // Animate solar system content
                if (fadeAmount > 0.5) {
                    document.querySelector('.solar-system-content').style.opacity = 1;
                    document.querySelector('.solar-system-content').style.transform = 'translateY(0)';
                } else {
                    document.querySelector('.solar-system-content').style.opacity = 0;
                    document.querySelector('.solar-system-content').style.transform = 'translateY(50px)';
                }
            });

            // --- AUDIO CONTROL ---
            const audioControl = document.querySelector('.audio-control');
            let audioEnabled = false;
            let audioContext = null;
            let oscillator = null;
            
            audioControl.addEventListener('click', () => {
                audioEnabled = !audioEnabled;
                audioControl.innerHTML = audioEnabled ? 
                    '<i class="fas fa-volume-up"></i>' : 
                    '<i class="fas fa-volume-mute"></i>';
                
                if (audioEnabled) {
                    // Initialize Web Audio API
                    audioContext = new (window.AudioContext || window.webkitAudioContext)();
                    oscillator = audioContext.createOscillator();
                    const gainNode = audioContext.createGain();
                    
                    oscillator.type = 'sine';
                    oscillator.frequency.setValueAtTime(110, audioContext.currentTime);
                    gainNode.gain.value = 0.05;
                    
                    oscillator.connect(gainNode);
                    gainNode.connect(audioContext.destination);
                    
                    oscillator.start();
                    
                    // Connect mouse movement to audio
                    window.addEventListener('mousemove', updateAudio);
                    if (isMobile) {
                        window.addEventListener('touchmove', updateAudio);
                    }
                } else {
                    if (oscillator) {
                        oscillator.stop();
                        window.removeEventListener('mousemove', updateAudio);
                        if (isMobile) {
                            window.removeEventListener('touchmove', updateAudio);
                        }
                    }
                }
            });
            
            function updateAudio(event) {
                if (!audioContext || !oscillator) return;
                
                let clientX, clientY;
                
                if (event.type === 'touchmove') {
                    clientX = event.touches[0].clientX;
                    clientY = event.touches[0].clientY;
                } else {
                    clientX = event.clientX;
                    clientY = event.clientY;
                }
                
                // Map position to frequency (110Hz to 880Hz)
                const freq = 110 + (clientX / window.innerWidth) * 770;
                oscillator.frequency.setValueAtTime(freq, audioContext.currentTime);
                
                // Map vertical position to volume
                const volume = 0.05 + (clientY / window.innerHeight) * 0.1;
                const gainNode = oscillator.context.createGain();
                gainNode.gain.value = volume;
            }
            
            // --- SETTINGS PANEL ---
            const settingsToggle = document.querySelector('.settings-toggle');
            const settingsPanel = document.querySelector('.settings-panel');
            const closeSettings = document.querySelector('.close-settings');
            
            settingsToggle.addEventListener('click', () => {
                settingsPanel.classList.toggle('open');
            });
            
            closeSettings.addEventListener('click', () => {
                settingsPanel.classList.remove('open');
            });
            
            // Close settings when clicking outside
            document.addEventListener('click', (e) => {
                if (settingsPanel.classList.contains('open') && 
                    !settingsPanel.contains(e.target) && 
                    !settingsToggle.contains(e.target)) {
                    settingsPanel.classList.remove('open');
                }
            });
            
            // Particle density control
            const particleDensitySlider = document.getElementById('particle-density');
            particleDensitySlider.addEventListener('input', () => {
                parameters.count = parseInt(particleDensitySlider.value);
                generateGalaxy();
            });
            
            // Bloom intensity control
            const bloomIntensitySlider = document.getElementById('bloom-intensity');
            bloomIntensitySlider.addEventListener('input', () => {
                composer.removePass(bloomPass);
                bloomPass = new UnrealBloomPass(
                    new THREE.Vector2(window.innerWidth, window.innerHeight), 
                    parseFloat(bloomIntensitySlider.value), 
                    0.6, 
                    0.4
                );
                composer.addPass(bloomPass);
            });
            
            // Mouse interaction strength
            const mouseInteractionSlider = document.getElementById('mouse-interaction');
            mouseInteractionSlider.addEventListener('input', () => {
                parameters.mouseInteractionStrength = parseFloat(mouseInteractionSlider.value);
            });
            
            // Color themes
            const colorThemes = document.querySelectorAll('.color-theme');
            colorThemes.forEach(theme => {
                theme.addEventListener('click', () => {
                    colorThemes.forEach(t => t.classList.remove('active'));
                    theme.classList.add('active');
                    
                    parameters.insideColor = theme.dataset.inner;
                    parameters.outsideColor = theme.dataset.outer;
                    generateGalaxy();
                });
            });

            // --- GSAP ANIMATIONS ---
            gsap.utils.toArray('.chapter-content').forEach(content => {
                gsap.fromTo(content, 
                    { opacity: 0, y: 40 }, 
                    {
                        opacity: 1,
                        y: 0,
                        duration: 1.5,
                        ease: 'power3.out',
                        scrollTrigger: {
                            trigger: content,
                            start: 'top 80%',
                            toggleActions: 'play none none reverse'
                        }
                    }
                );
            });

            const mainTimeline = gsap.timeline({
                scrollTrigger: {
                    trigger: ".story-content",
                    start: "top top",
                    end: "bottom bottom",
                    scrub: 1.5
                }
            });

            mainTimeline
                .to(camera.position, { z: 4, ease: 'power1.in' }, 0)
                .to(points.rotation, { y: Math.PI * 0.5, ease: 'power1.inOut' }, 0)
                .to(camera.position, { z: 0.5, ease: 'power1.out' }, 1)
                .to(points.rotation, { y: Math.PI, z: -Math.PI * 0.2, ease: 'power1.inOut' }, 1)
                .to(camera.position, { x: 2, z: -3, ease: 'power2.inOut' }, 2)
                .to(points.rotation, { y: Math.PI * 1.5, z: -Math.PI * 0.4, ease: 'power2.inOut' }, 2)
                .to(camera.position, { x: 0, z: 6, ease: 'power2.in' }, 3)
                .to(points.rotation, { y: Math.PI * 2, z: 0, ease: 'power2.inOut' }, 3);

            // --- PERFORMANCE OPTIMIZATIONS ---
            let frameCount = 0;
            const maxFPS = isMobile ? 30 : 60; // Lower FPS on mobile for better battery life
            let then = 0;
            const interval = 1000 / maxFPS;
            
            // Only update a portion of particles each frame for mouse interaction
            const particlesPerFrame = Math.floor(parameters.count / 10); // Update 10% of particles per frame
            let particleIndex = 0;
            
            // Smooth mouse movement with lerp
            const smoothMouseFactor = 0.1;
            
            // Create a single reusable vector for performance
            const particlePos = new THREE.Vector3();
            const displacement = new THREE.Vector3();
            
            // --- RENDER LOOP ---
            const clock = new THREE.Clock();
            const raycaster = new THREE.Raycaster();
            const plane = new THREE.Plane(new THREE.Vector3(0, 0, 1), 0);
            const intersectPoint = new THREE.Vector3();

            const animate = (now) => {
                // Request next frame
                requestAnimationFrame(animate);
                
                // Control frame rate
                const delta = now - then;
                if (delta < interval) return;
                then = now - (delta % interval);
                
                const elapsedTime = clock.getElapsedTime();
                points.rotation.y = elapsedTime * 0.05;

                // Smooth mouse movement
                currentMousePos.lerp(targetMousePos, smoothMouseFactor);
                mouse.x = currentMousePos.x;
                mouse.y = currentMousePos.y;

                // --- OPTIMIZED MOUSE INTERACTION LOGIC ---
                // Project mouse onto a 3D plane
                raycaster.setFromCamera(mouse, camera);
                raycaster.ray.intersectPlane(plane, intersectPoint);

                const positions = geometry.attributes.position.array;
                
                // Only update a subset of particles each frame
                for (let i = 0; i < particlesPerFrame; i++) {
                    const idx = (particleIndex + i) % parameters.count;
                    const i3 = idx * 3;
                    
                    const originalX = originalPositions[i3];
                    const originalY = originalPositions[i3 + 1];
                    const originalZ = originalPositions[i3 + 2];
                    
                    particlePos.set(originalX, originalY, originalZ);
                    const distance = particlePos.distanceTo(intersectPoint);
                    
                    if (distance < 2.0) { // Only update if particle is close to mouse
                        const force = Math.max(0, 1 - distance / 2.0);
                        displacement.copy(particlePos).sub(intersectPoint).normalize().multiplyScalar(force * parameters.mouseInteractionStrength);
                        
                        // Apply damping for smoother movement
                        positions[i3] = originalX + displacement.x * 0.3 + (positions[i3] - originalX) * 0.7;
                        positions[i3 + 1] = originalY + displacement.y * 0.3 + (positions[i3 + 1] - originalY) * 0.7;
                        positions[i3 + 2] = originalZ + displacement.z * 0.3 + (positions[i3 + 2] - originalZ) * 0.7;
                    } else {
                        // Return to original position with damping
                        positions[i3] = originalX + (positions[i3] - originalX) * 0.9;
                        positions[i3 + 1] = originalY + (positions[i3 + 1] - originalY) * 0.9;
                        positions[i3 + 2] = originalZ + (positions[i3 + 2] - originalZ) * 0.9;
                    }
                }
                
                // Update the starting point for next frame
                particleIndex = (particleIndex + particlesPerFrame) % parameters.count;
                
                geometry.attributes.position.needsUpdate = true;
                // --- END MOUSE INTERACTION LOGIC ---

                composer.render();
                frameCount++;
            };
            animate(0);

            // --- RESPONSIVENESS ---
            window.addEventListener('resize', () => {
                camera.aspect = window.innerWidth / window.innerHeight;
                camera.updateProjectionMatrix();
                renderer.setSize(window.innerWidth, window.innerHeight);
                composer.setSize(window.innerWidth, window.innerHeight);
                renderer.setPixelRatio(Math.min(window.devicePixelRatio, isMobile ? 1 : 2));
            });

            // --- STEAMPUNK ORRERY IMPLEMENTATION ---
            const initSolarSystem = () => {
                const solarSystemRenderer = new THREE.WebGLRenderer({ 
                    canvas: solarSystemCanvas, 
                    antialias: true,
                    powerPreference: "high-performance",
                    alpha: true
                });
                solarSystemRenderer.setSize(window.innerWidth, window.innerHeight);
                solarSystemRenderer.setPixelRatio(Math.min(window.devicePixelRatio, isMobile ? 1 : 2));
                
                const solarSystemScene = new THREE.Scene();
                solarSystemScene.fog = new THREE.FogExp2(0x000000, 0.0015);
                
                const solarSystemCamera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 1000);
                // Adjust camera position for mobile
                solarSystemCamera.position.set(isMobile ? 30 : 20, isMobile ? 40 : 30, isMobile ? 70 : 50);
                solarSystemCamera.lookAt(solarSystemScene.position);

                // --- POST-PROCESSING (BLOOM EFFECT) ---
                const renderScene = new RenderPass(solarSystemScene, solarSystemCamera);
                const bloomPass = new UnrealBloomPass(new THREE.Vector2(window.innerWidth, window.innerHeight), 1.5, 0.4, 0.85);
                bloomPass.threshold = 0;
                bloomPass.strength = isMobile ? 1.0 : 1.2; // Reduce bloom strength on mobile
                bloomPass.radius = 0.5;

                const composer = new EffectComposer(solarSystemRenderer);
                composer.addPass(renderScene);
                composer.addPass(bloomPass);

                // --- CONTROLS ---
                const controls = new OrbitControls(solarSystemCamera, solarSystemRenderer.domElement);
                controls.enableDamping = true;
                controls.dampingFactor = 0.05;
                controls.screenSpacePanning = false;
                controls.minDistance = isMobile ? 30 : 20;
                controls.maxDistance = isMobile ? 250 : 200;
                controls.enableZoom = true;
                controls.enablePan = !isMobile; // Disable pan on mobile for better UX

                // --- LIGHTING ---
                const ambientLight = new THREE.AmbientLight(0x404040, 2);
                solarSystemScene.add(ambientLight);

                const sunLight = new THREE.PointLight(0xffeeb1, 5, 500);
                sunLight.position.set(0, 0, 0);
                solarSystemScene.add(sunLight);

                // --- CREATE THE ORRERY ---
                const objects = []; // To store animated objects

                // PBR materials for a metallic look
                const brassMaterial = new THREE.MeshStandardMaterial({
                    color: 0xb08c54,
                    metalness: 0.9,
                    roughness: 0.3,
                    flatShading: false
                });

                const copperMaterial = new THREE.MeshStandardMaterial({
                    color: 0xb87333,
                    metalness: 0.9,
                    roughness: 0.4
                });
                
                const darkMetalMaterial = new THREE.MeshStandardMaterial({
                    color: 0x222222,
                    metalness: 1.0,
                    roughness: 0.5
                });

                // Function to create a gear
                function createGear(radius, thickness, teeth, toothHeight, toothWidth) {
                    const shape = new THREE.Shape();
                    const angleStep = (Math.PI * 2) / teeth;

                    for (let i = 0; i < teeth; i++) {
                        const angle = i * angleStep;
                        const nextAngle = (i + 1) * angleStep;
                        
                        // Base of the tooth
                        shape.moveTo(Math.cos(angle) * radius, Math.sin(angle) * radius);
                        
                        // Tip of the tooth
                        shape.lineTo(Math.cos(angle + toothWidth) * (radius + toothHeight), Math.sin(angle + toothWidth) * (radius + toothHeight));
                        shape.lineTo(Math.cos(nextAngle - toothWidth) * (radius + toothHeight), Math.sin(nextAngle - toothWidth) * (radius + toothHeight));
                        
                        // Next base
                        shape.lineTo(Math.cos(nextAngle) * radius, Math.sin(nextAngle) * radius);
                    }

                    const extrudeSettings = {
                        steps: 1,
                        depth: thickness,
                        bevelEnabled: true,
                        bevelThickness: 0.2,
                        bevelSize: 0.1,
                        bevelSegments: 2
                    };

                    const geometry = new THREE.ExtrudeGeometry(shape, extrudeSettings);
                    geometry.center();
                    const gear = new THREE.Mesh(geometry, brassMaterial);
                    return gear;
                }

                // Function to create a planet system
                function createPlanet(size, color, distance, speed, hasRing = false) {
                    const pivot = new THREE.Object3D();
                    solarSystemScene.add(pivot);

                    // Planet
                    const planetMaterial = new THREE.MeshStandardMaterial({ color: color, metalness: 0.3, roughness: 0.6 });
                    const planet = new THREE.Mesh(new THREE.SphereGeometry(size, 32, 32), planetMaterial);
                    planet.position.x = distance;
                    pivot.add(planet);
                    
                    // Ring
                    if (hasRing) {
                        const ringMaterial = new THREE.MeshBasicMaterial({ color: 0x7a6a5f, side: THREE.DoubleSide, transparent: true, opacity: 0.8 });
                        const ring = new THREE.Mesh(new THREE.RingGeometry(size * 1.5, size * 2, 64), ringMaterial);
                        ring.rotation.x = Math.PI / 2;
                        planet.add(ring);
                    }

                    // Orbital Path (visual only)
                    const pathGeometry = new THREE.BufferGeometry().setFromPoints(
                        new THREE.Path().absarc(0, 0, distance, 0, Math.PI * 2, false).getSpacedPoints(200)
                    );
                    const pathMaterial = new THREE.LineBasicMaterial({ color: 0x444444 });
                    const orbitalPath = new THREE.Line(pathGeometry, pathMaterial);
                    orbitalPath.rotation.x = Math.PI / 2;
                    solarSystemScene.add(orbitalPath);

                    // Animation data
                    objects.push({
                        object: pivot,
                        type: 'orbit',
                        speed: speed
                    });
                    objects.push({
                        object: planet,
                        type: 'spin',
                        speed: speed * 2
                    });

                    return pivot;
                }
                
                function createOrrery() {
                    // --- CENTRAL SUN ---
                    const sunMaterial = new THREE.MeshBasicMaterial({ color: 0xffdd88 });
                    const sun = new THREE.Mesh(new THREE.SphereGeometry(10, 64, 64), sunMaterial);
                    solarSystemScene.add(sun);

                    // --- PLANETS ---
                    createPlanet(2, 0x9a7f6f, 25, 0.5); // Mercury-like
                    createPlanet(3.5, 0xd4a05f, 45, 0.3, true); // Saturn-like
                    createPlanet(3, 0x5f8ad4, 70, 0.2); // Earth-like
                    createPlanet(2.5, 0xd45f5f, 95, 0.1); // Mars-like

                    // --- MECHANICAL STRUCTURE & GEARS ---
                    const mainShaft = new THREE.Mesh(new THREE.CylinderGeometry(1, 1, 30, 16), darkMetalMaterial);
                    mainShaft.position.y = -15;
                    solarSystemScene.add(mainShaft);

                    const base = new THREE.Mesh(new THREE.CylinderGeometry(15, 15, 2, 32), darkMetalMaterial);
                    base.position.y = -31;
                    solarSystemScene.add(base);

                    // Large central gear
                    const centralGear = createGear(18, 2, 48, 2, 0.02);
                    centralGear.rotation.x = Math.PI / 2;
                    centralGear.position.y = -5;
                    solarSystemScene.add(centralGear);
                    objects.push({ object: centralGear, type: 'spin', speed: 0.05 });

                    // Smaller interconnected gears
                    const gear1 = createGear(8, 1.5, 24, 1.5, 0.04);
                    gear1.rotation.x = Math.PI / 2;
                    gear1.position.set(26, -5, 0);
                    solarSystemScene.add(gear1);
                    objects.push({ object: gear1, type: 'spin', speed: -0.1 });

                    const gear2 = createGear(6, 1.5, 18, 1, 0.05);
                    gear2.rotation.x = Math.PI / 2;
                    gear2.position.set(-24, -5, 0);
                    solarSystemScene.add(gear2);
                    objects.push({ object: gear2, type: 'spin', speed: 0.133 });
                }

                createOrrery();

                // Clock for animations
                const clock = new THREE.Clock();
                
                // Animation for solar system
                const animateSolarSystem = () => {
                    requestAnimationFrame(animateSolarSystem);
                    
                    const delta = clock.getDelta();
                    const elapsedTime = clock.getElapsedTime();

                    // Animate all registered objects
                    objects.forEach(objData => {
                        if (objData.type === 'orbit') {
                            objData.object.rotation.y += objData.speed * delta;
                        } else if (objData.type === 'spin') {
                            objData.object.rotation.z += objData.speed * delta;
                        }
                    });

                    controls.update();
                    composer.render();
                };
                
                // Start animation
                animateSolarSystem();
                
                // Handle resize
                window.addEventListener('resize', () => {
                    solarSystemCamera.aspect = window.innerWidth / window.innerHeight;
                    solarSystemCamera.updateProjectionMatrix();
                    solarSystemRenderer.setSize(window.innerWidth, window.innerHeight);
                    composer.setSize(window.innerWidth, window.innerHeight);
                });

                // --- MOBILE CONTROLS ---
                if (isMobile) {
                    let rotationPaused = false;
                    let speedMultiplier = 1;
                    let zoomLevel = 50;
                    
                    document.getElementById('mobile-zoom-in').addEventListener('click', () => {
                        zoomLevel = Math.max(30, zoomLevel - 10);
                        solarSystemCamera.position.set(
                            Math.cos(cameraAngle) * zoomLevel,
                            solarSystemCamera.position.y,
                            Math.sin(cameraAngle) * zoomLevel
                        );
                    });
                    
                    document.getElementById('mobile-zoom-out').addEventListener('click', () => {
                        zoomLevel = Math.min(150, zoomLevel + 10);
                        solarSystemCamera.position.set(
                            Math.cos(cameraAngle) * zoomLevel,
                            solarSystemCamera.position.y,
                            Math.sin(cameraAngle) * zoomLevel
                        );
                    });
                    
                    document.getElementById('mobile-pause').addEventListener('click', () => {
                        rotationPaused = !rotationPaused;
                        document.getElementById('mobile-pause').innerHTML = rotationPaused ? 
                            '<i class="fas fa-play"></i>' : 
                            '<i class="fas fa-pause"></i>';
                    });
                    
                    document.getElementById('mobile-speed').addEventListener('click', () => {
                        speedMultiplier = speedMultiplier === 1 ? 3 : 1;
                        document.getElementById('mobile-speed').style.background = speedMultiplier === 3 ? 
                            'rgba(255, 105, 180, 0.6)' : 
                            'rgba(255, 105, 180, 0.3)';
                    });
                }
            };
            
            // Initialize solar system after a short delay
            setTimeout(initSolarSystem, 1000);
        }
    </script>
</body>
</html>
