import {UserConfigFn} from 'vite';
import {overrideVaadinConfig} from './vite.generated';

const customConfig: UserConfigFn = (env) => ({
  // Here you can add custom Vite parameters
  // https://vitejs.dev/config/
    build: {
        chunkSizeWarningLimit: 1000 // aumenta el límite a 1000 kBs
    }
});

export default overrideVaadinConfig(customConfig);
