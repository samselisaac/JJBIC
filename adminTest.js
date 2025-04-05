process.env.FIREBASE_AUTH_EMULATOR_HOST = '127.0.0.1:9099';

const admin = require('firebase-admin');
admin.initializeApp({
  projectId: 'inventorymanagement-af53a'
});

admin.auth().listUsers()
  .then((result) => {
    console.log('Users:', result.users);
  })
  .catch((error) => {
    console.error('Error listing users:', error);
  });
