import http from 'k6/http';
import { check, sleep } from 'k6';

export let options = {
  insecureSkipTLSVerify: true,
  noConnectionReuse: false,
  vus: 1,
  duration: '30s'
};

export default () => {
  let question = http.get('http://localhost:3001/qa/questions?product_id=1');
  let answer = http.get('http://localhost:3001/qa/questions/1/answers');
  check(question, { 'status was 200': r => r.status == 200 });
  sleep(1)
};