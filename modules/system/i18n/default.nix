{
  ...
}:
{
  timeZone ? "Europe/London",
  locale ? "en_GB.UTF-8",
  keyboardLayout ? "gb",
}:
{
  i18n.defaultLocale = locale;

  console.useXkbConfig = true;
  services.xserver.xkb.layout = keyboardLayout;

  time.timeZone = timeZone;
}
