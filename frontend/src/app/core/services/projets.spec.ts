import { TestBed } from '@angular/core/testing';
import { provideHttpClient } from '@angular/common/http';
import { provideHttpClientTesting } from '@angular/common/http/testing';

import { Projets } from './projets';

describe('Projets', () => {
  let service: Projets;

  beforeEach(() => {
    TestBed.configureTestingModule({
      providers: [provideHttpClient(), provideHttpClientTesting()],
    });
    service = TestBed.inject(Projets);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
