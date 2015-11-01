import 'bootstrap';

export class App {
  configureRouter(config, router){
    config.title = 'Light';
    config.map([
      { route: ['','welcome'], name: 'welcome', moduleId: 'welcome', nav: true, title:'Welcome' },
      { route: ['color'], name: 'color', moduleId: 'color', nav: true, title:'Color' },
      { route: ['wavelength'], name: 'wavelength', moduleId: 'wavelength', nav: true, title:'Wavelength' }
    ]);

    this.router = router;
  }
}