# Cara Melihat Flutter App di Codespaces

## ❌ Port 5900 - BUKAN untuk Browser!

Port 5900 adalah **VNC server** - protokol remote desktop, BUKAN web server.
Browser biasa tidak bisa membuka VNC protocol.

## ✅ 3 Cara Melihat App:

---

## 1️⃣ Flutter Web (PALING MUDAH) 🌐

### Run Flutter App sebagai Web App:
```bash
flutter run -d web-server --web-hostname 0.0.0.0 --web-port 8080
```

### Akses di Browser:
```
https://[your-codespace-name]-8080.app.github.dev
```

**Contoh:**
```
https://stunning-umbrella-v6r9x967jjv4c66qp-8080.app.github.dev
```

✅ **Langsung bisa dibuka di browser**
✅ **Tidak perlu VNC client**
✅ **Hot reload works**

---

## 2️⃣ VNC dengan Desktop Client 🖥️

Jika ingin lihat Linux desktop app via VNC:

### Step 1: Start VNC Server
```bash
bash .devcontainer/start-display.sh
```

### Step 2: Forward Port 5900
- Di VS Code: Ports panel → Forward Port → 5900

### Step 3: Install VNC Client
- **Windows**: Download [TigerVNC](https://tigervnc.org/) atau [RealVNC](https://www.realvnc.com/)
- **macOS**: Built-in! (Finder → Go → Connect to Server)
- **Linux**: Remmina atau TigerVNC

### Step 4: Connect
- **Address**: `localhost:5900`
- **Password**: `codespace`

❌ **TIDAK bisa dibuka di browser biasa**
✅ **Perlu VNC client**

---

## 3️⃣ noVNC - VNC di Browser 🌐🖥️

Setup web-based VNC viewer:

### Install noVNC:
```bash
# Install novnc
cd /tmp
git clone https://github.com/novnc/noVNC.git
cd noVNC

# Start websockify proxy
./utils/novnc_proxy --vnc localhost:5900 --listen 6080
```

### Akses di Browser:
```
https://[your-codespace-name]-6080.app.github.dev/vnc.html
```

Password: `codespace`

✅ **Bisa dibuka di browser**
✅ **Lihat Linux desktop app**

---

## 📝 Quick Commands

### Run Web Version (Recommended):
```bash
# Method 1: Flutter web server
flutter run -d web-server --web-hostname 0.0.0.0 --web-port 8080

# Method 2: Build and serve
flutter build web
cd build/web
python3 -m http.server 8080
```

Lalu buka: `https://[codespace]-8080.app.github.dev`

### Run Linux Desktop (dengan VNC):
```bash
# 1. Start display & VNC
bash .devcontainer/start-display.sh

# 2. Run Flutter app
flutter run -d linux

# 3. Connect dengan VNC client ke localhost:5900
```

---

## 🎯 Ringkasan Port Usage

| Port | Service | Akses Via | URL |
|------|---------|-----------|-----|
| 5900 | VNC Server | VNC Client | `localhost:5900` ❌ Browser |
| 6080 | noVNC | Browser | `https://[codespace]-6080.app.github.dev/vnc.html` ✅ |
| 8080 | Flutter Web | Browser | `https://[codespace]-8080.app.github.dev` ✅ |

---

## 🚀 Rekomendasi

### Untuk Development & Testing:
**Flutter Web** - Paling mudah dan cepat
```bash
flutter run -d web-server --web-hostname 0.0.0.0 --web-port 8080
```

### Untuk Melihat Desktop App:
**VNC dengan Desktop Client** - Performa terbaik
```bash
bash .devcontainer/start-display.sh
# Connect via VNC client
```

### Untuk Demo via Browser:
**noVNC** - Convenient tapi agak lambat
```bash
# Setup noVNC dulu (one-time)
cd /tmp && git clone https://github.com/novnc/noVNC.git
cd noVNC && ./utils/novnc_proxy --vnc localhost:5900 --listen 6080
```

---

## 🔧 Troubleshooting

### "Connection refused" di port 5900
```bash
# Restart VNC server
bash .devcontainer/start-display.sh
```

### "Blank page" di port 5900 via browser
❌ **Port 5900 TIDAK bisa dibuka di browser!**
✅ **Gunakan VNC client atau noVNC**

### Flutter web tidak load
```bash
# Check jika server running
flutter run -d web-server --web-hostname 0.0.0.0 --web-port 8080

# Forward port 8080 di VS Code
# Buka: https://[codespace]-8080.app.github.dev
```

### Port sudah digunakan
```bash
# Kill existing process
lsof -ti:8080 | xargs kill -9

# Atau gunakan port lain
flutter run -d web-server --web-hostname 0.0.0.0 --web-port 8081
```

---

## 📚 More Info

- VNC adalah remote desktop protocol, bukan HTTP
- Browser butuh HTTP/HTTPS protocol
- noVNC adalah bridge antara VNC ↔ WebSocket ↔ Browser
- Flutter web compile ke JavaScript, bisa langsung di browser

---

**TL;DR:** 
- ❌ Port 5900 tidak bisa dibuka di browser
- ✅ Gunakan port 8080 untuk Flutter web
- ✅ Atau gunakan VNC client untuk port 5900
