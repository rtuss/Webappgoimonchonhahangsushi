import axios from 'axios';

async function test() {
  try {
    console.log('Testing login...');
    const response = await axios.post('http://localhost:3000/api/auth/login', {
      email: 'admin@sushi.com',
      password: 'admin@123'
    });
    
    console.log('✅ Login Success:');
    console.log(response.data);
    const token = response.data.data.token;
    console.log('\n✅ Token:', token.substring(0, 20) + '...');
    
    console.log('\n📊 Testing get users...');
    const usersResponse = await axios.get('http://localhost:3000/api/admin/users', {
      headers: {
        'Authorization': `Bearer ${token}`
      }
    });
    
    console.log('✅ Users found:', usersResponse.data.length);
    console.log(usersResponse.data);
    
  } catch (err) {
    console.error('❌ Full Error:', {
      message: err.message,
      status: err.response?.status,
      data: err.response?.data,
      code: err.code
    });
  }
}

test();
