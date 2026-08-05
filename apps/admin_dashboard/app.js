const navItems = [...document.querySelectorAll('.nav-item[data-view]')];
const views = [...document.querySelectorAll('.view')];
const pageTitle = document.getElementById('pageTitle');
const sidebar = document.getElementById('sidebar');
const mobileMenu = document.getElementById('mobileMenu');
const search = document.getElementById('globalSearch');
const toast = document.getElementById('toast');

const titles = {
  overview: 'Marketplace overview',
  orders: 'Order operations',
  vendors: 'Vendor management',
  drivers: 'Driver operations',
  customers: 'Customer support',
  payments: 'Payments and reconciliation',
  promotions: 'Promotion engine',
  reports: 'Reports and analytics',
  settings: 'Platform configuration',
};

function showView(name) {
  navItems.forEach((item) => item.classList.toggle('active', item.dataset.view === name));
  views.forEach((view) => view.classList.toggle('active', view.id === `${name}-view`));
  pageTitle.textContent = titles[name] ?? 'Biloo Operations';
  sidebar.classList.remove('open');
  window.scrollTo({ top: 0, behavior: 'smooth' });
}

function showToast(message) {
  toast.textContent = message;
  toast.classList.add('visible');
  window.clearTimeout(showToast.timeout);
  showToast.timeout = window.setTimeout(() => toast.classList.remove('visible'), 2600);
}

navItems.forEach((item) => item.addEventListener('click', () => showView(item.dataset.view)));
document.querySelectorAll('[data-view-jump]').forEach((button) => {
  button.addEventListener('click', () => showView(button.dataset.viewJump));
});

mobileMenu.addEventListener('click', () => sidebar.classList.toggle('open'));

document.addEventListener('click', (event) => {
  if (window.innerWidth > 860) return;
  if (!sidebar.contains(event.target) && !mobileMenu.contains(event.target)) sidebar.classList.remove('open');
});

search.addEventListener('input', (event) => {
  const query = event.target.value.trim().toLowerCase();
  document.querySelectorAll('#ordersTable tbody tr').forEach((row) => {
    row.hidden = query.length > 0 && !row.dataset.search.toLowerCase().includes(query);
  });
});

document.getElementById('exportButton').addEventListener('click', () => {
  const rows = [...document.querySelectorAll('#ordersTable tbody tr:not([hidden])')];
  const csv = ['Order,Customer,Vendor,Driver,Total,Status']
    .concat(rows.map((row) => [...row.cells].slice(0, 6).map((cell) => `"${cell.innerText.trim().replaceAll('"', '""')}"`).join(',')))
    .join('\n');
  const blob = new Blob([csv], { type: 'text/csv;charset=utf-8' });
  const url = URL.createObjectURL(blob);
  const anchor = document.createElement('a');
  anchor.href = url;
  anchor.download = `biloo-orders-${new Date().toISOString().slice(0, 10)}.csv`;
  anchor.click();
  URL.revokeObjectURL(url);
  showToast('Order report exported successfully.');
});

document.querySelectorAll('.approve').forEach((button) => {
  button.addEventListener('click', () => showToast('Vendor review workspace will open after Supabase is connected.'));
});

document.querySelectorAll('.row-action').forEach((button) => {
  button.addEventListener('click', () => showToast('Detailed operations drawer is ready for backend wiring.'));
});
