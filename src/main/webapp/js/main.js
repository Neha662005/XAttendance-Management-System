// ── Sidebar toggle (mobile) ───────────────────────────────────────────────────
function toggleSidebar() {
    var sidebar = document.getElementById('sidebar');
    if (sidebar) sidebar.classList.toggle('open');
}

document.addEventListener('click', function(e) {
    var sidebar = document.getElementById('sidebar');
    var toggle  = document.getElementById('sidebarToggle');
    if (!sidebar || !toggle) return;
    if (!sidebar.contains(e.target) && !toggle.contains(e.target)) {
        sidebar.classList.remove('open');
    }
});

function checkScreenSize() {
    var toggle = document.getElementById('sidebarToggle');
    if (!toggle) return;
    if (window.innerWidth <= 1024) {
        toggle.style.display = 'flex';
    } else {
        toggle.style.display = 'none';
        var sidebar = document.getElementById('sidebar');
        if (sidebar) sidebar.classList.remove('open');
    }
}

window.addEventListener('resize', checkScreenSize);
document.addEventListener('DOMContentLoaded', checkScreenSize);

// ── Flash message auto-dismiss ────────────────────────────────────────────────
document.addEventListener('DOMContentLoaded', function() {
    var alerts = document.querySelectorAll('.alert');
    alerts.forEach(function(alert) {
        setTimeout(function() {
            alert.style.transition = 'opacity 0.4s ease';
            alert.style.opacity    = '0';
            setTimeout(function() {
                if (alert.parentNode) alert.parentNode.removeChild(alert);
            }, 400);
        }, 4000);
    });
});

// ── Dropdown menus ────────────────────────────────────────────────────────────
function toggleDropdown(id) {
    var menu = document.getElementById(id);
    if (!menu) return;
    menu.classList.toggle('show');
}

document.addEventListener('click', function(e) {
    if (!e.target.closest('.dropdown')) {
        document.querySelectorAll('.dropdown-menu.show').forEach(function(m) {
            m.classList.remove('show');
        });
    }
});

// ── Modal helpers ─────────────────────────────────────────────────────────────
function openModal(id) {
    var overlay = document.getElementById(id);
    if (overlay) overlay.classList.add('show');
}

function closeModal(id) {
    var overlay = document.getElementById(id);
    if (overlay) overlay.classList.remove('show');
}

document.addEventListener('click', function(e) {
    if (e.target.classList.contains('modal-overlay')) {
        e.target.classList.remove('show');
    }
});

// ── Password show/hide toggle ─────────────────────────────────────────────────
function togglePassword(inputId, btnId) {
    var input = document.getElementById(inputId);
    var btn   = document.getElementById(btnId);
    if (!input) return;
    if (input.type === 'password') {
        input.type = 'text';
        if (btn) btn.innerHTML = hideSVG();
    } else {
        input.type = 'password';
        if (btn) btn.innerHTML = showSVG();
    }
}

function showSVG() {
    return '<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>';
}

function hideSVG() {
    return '<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M17.94 17.94A10.07 10.07 0 0112 20c-7 0-11-8-11-8a18.45 18.45 0 015.06-5.94M9.9 4.24A9.12 9.12 0 0112 4c7 0 11 8 11 8a18.5 18.5 0 01-2.16 3.19m-6.72-1.07a3 3 0 11-4.24-4.24"/><line x1="1" y1="1" x2="23" y2="23"/></svg>';
}

// ── Password match checker ────────────────────────────────────────────────────
function checkPasswordMatch(passId, confirmId, hintId) {
    var pass    = document.getElementById(passId);
    var confirm = document.getElementById(confirmId);
    var hint    = document.getElementById(hintId);
    if (!pass || !confirm || !hint) return;

    if (confirm.value.length === 0) {
        hint.style.display = 'none';
        return;
    }

    hint.style.display = 'block';
    if (pass.value === confirm.value) {
        hint.style.color   = '#166534';
        hint.textContent   = '✓ Passwords match';
    } else {
        hint.style.color   = '#991b1b';
        hint.textContent   = '✗ Passwords do not match';
    }
}

// ── Dynamic dept + shift loader (register page) ───────────────────────────────
function loadDeptAndShift(orgId, ctx) {
    var deptSelect  = document.getElementById('deptId');
    var shiftSelect = document.getElementById('shiftId');
    if (!deptSelect || !shiftSelect) return;

    if (!orgId) {
        deptSelect.innerHTML  = '<option value="">— Select organization first —</option>';
        shiftSelect.innerHTML = '<option value="">— Select organization first —</option>';
        return;
    }

    deptSelect.innerHTML  = '<option value="">Loading...</option>';
    shiftSelect.innerHTML = '<option value="">Loading...</option>';

    fetch(ctx + '/getDepartments?orgId=' + orgId)
        .then(function(res) { return res.json(); })
        .then(function(data) {
            deptSelect.innerHTML = '<option value="">— Select department —</option>';
            data.departments.forEach(function(d) {
                var opt = document.createElement('option');
                opt.value       = d.id;
                opt.textContent = d.name;
                deptSelect.appendChild(opt);
            });

            shiftSelect.innerHTML = '<option value="">— Select shift —</option>';
            data.shifts.forEach(function(s) {
                var opt = document.createElement('option');
                opt.value       = s.id;
                opt.textContent = s.name + ' (' + s.time + ')';
                shiftSelect.appendChild(opt);
            });
        })
        .catch(function() {
            deptSelect.innerHTML  = '<option value="">Could not load</option>';
            shiftSelect.innerHTML = '<option value="">Could not load</option>';
        });
}

// ── Confirm before destructive actions ────────────────────────────────────────
function confirmAction(message) {
    return window.confirm(message || 'Are you sure?');
}