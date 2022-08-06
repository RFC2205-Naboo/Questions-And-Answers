import http from 'k6/http';
import { check, sleep } from 'k6';

// Simple Testing
export let options = {
  insecureSkipTLSVerify: true,
  noConnectionReuse: false,
  vus: 100,
  duration: '30s',
};


// Load Testing
// export let options = {
//   insecureSkipTLSVerify: true,
//   noConnectionReuse: false,
//   stages: [
//     {duration: '15s', target: 100 },
//     {duration: '30s', target: 100 },
//     {duration: '15s', target: 0},
//   ],
// };


// Stress Testing
// export let options = {
//   insecureSkipTLSVerify: true,
//   noConnectionReuse: false,
//   stages: [
//     {duration: '15s', target: 100 },
//     {duration: '15s', target: 100 },
//     {duration: '30s', target: 200},
//     {duration: '30s', target: 200 },
//     {duration: '30s', target: 300 },
//     {duration: '30s', target: 300},
//     {duration: '1m', target: 400 },
//     {duration: '30s', target: 400 },
//     {duration: '15s', target: 0},
//   ],
// };

// Stress Testing extreme
// export let options = {
//   insecureSkipTLSVerify: true,
//   noConnectionReuse: false,
//   stages: [
//     {duration: '15s', target: 200 },
//     {duration: '15s', target: 200 },
//     {duration: '15s', target: 400},
//     {duration: '15s', target: 400 },
//     {duration: '15s', target: 600 },
//     {duration: '15s', target: 600},
//     {duration: '15s', target: 800 },
//     {duration: '15s', target: 800 },
//     {duration: '15s', target: 1000 },
//     {duration: '30s', target: 1000 },
//     {duration: '15s', target: 0},
//   ],
// };

export default () => {
  // let question = http.get('http://localhost:3001/qa/questions?product_id=1');
  let answer = http.get('http://localhost:3001/qa/questions/1/answers');
  check(answer, { 'status was 200': r => r.status == 200 });
  sleep(1)
};