export class Wavelength{
	heading = 'Wavelength of Light';
	wavelength;
	
	get imageWidth() {
		if (!this.wavelength) {
			return 0;
		}
		else {
			return this.wavelength;
		}
	}
}