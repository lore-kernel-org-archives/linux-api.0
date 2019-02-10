From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 14/19] io_uring: add file set registration
Date: Sat, 9 Feb 2019 17:47:09 -0700
Message-ID: <73a49fa3-9c42-4b25-4a6c-75749e5c0cea@kernel.dk>
References: <20190209211346.26060-1-axboe@kernel.dk>
 <20190209211346.26060-15-axboe@kernel.dk>
 <f722cc1a73bd7615d71fb020e87e5439f59947d7.camel@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <f722cc1a73bd7615d71fb020e87e5439f59947d7.camel@fb.com>
Content-Language: en-US
Sender: owner-linux-aio@kvack.org
To: Matt Mullins <mmullins@fb.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-aio@kvack.org" <linux-aio@kvack.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
Cc: "hch@lst.de" <hch@lst.de>, "jannh@google.com" <jannh@google.com>, "viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>, "avi@scylladb.com" <avi@scylladb.com>, "jmoyer@redhat.com" <jmoyer@redhat.com>
List-Id: linux-api@vger.kernel.org

On 2/9/19 4:52 PM, Matt Mullins wrote:
>> @@ -1292,6 +1338,154 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
>>  	return READ_ONCE(ring->r.head) == READ_ONCE(ring->r.tail) ? ret : 0;
>>  }
>>  
>> +static void __io_sqe_files_unregister(struct io_ring_ctx *ctx)
>> +{
>> +#if defined(CONFIG_UNIX)
>> +	if (ctx->ring_sock) {
>> +		struct sock *sock = ctx->ring_sock->sk;
>> +		struct sk_buff *skb;
>> +
>> +		while ((skb = skb_dequeue(&sock->sk_receive_queue)) != NULL)
> 
> Something's still a bit messy with destruction.  I get a traceback here
> while running
> 
>   int main() {
>     struct io_uring_params uring_params = {
>         .flags = IORING_SETUP_SQPOLL | IORING_SETUP_IOPOLL,
>     };
>     int uring_fd = 
>         syscall(425 /* io_uring_setup */, 16, &uring_params);
>     
>     const __s32 fds[] = {1};
>     
>     syscall(427 /* io_uring_register */, uring_fd,
>             IORING_REGISTER_FILES, fds, sizeof(fds) / sizeof(*fds));
>   }
> 
> I end up with the following spew:
> 
> [  195.983322] WARNING: CPU: 1 PID: 1938 at ../net/unix/af_unix.c:500 unix_sock_destructor+0x97/0xc0
> [  195.989556] Modules linked in:
> [  195.992738] CPU: 1 PID: 1938 Comm: aio_buffered Tainted: G        W         5.0.0-rc5+ #379
> [  196.000926] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1ubuntu1 04/01/2014
> [  196.008316] RIP: 0010:unix_sock_destructor+0x97/0xc0
> [  196.010912] Code: 3f 37 f3 ff 5b 5d be 00 02 00 00 48 c7 c7 6c 5b 9a 81 e9 8c 2a 71 ff 48 89 ef e8 c4 dc 87 ff eb be 0f 0b 48 83 7b 70 00 74 8b <0f> 0b 48 83 bb 68 02 00 00 00 74 89 0f 0b eb 85 48 89 de 48 c7 c7
> [  196.018887] RSP: 0018:ffffc900008a7d40 EFLAGS: 00010282
> [  196.020754] RAX: 0000000000000000 RBX: ffff8881351dd000 RCX: 0000000000000000
> [  196.022811] RDX: 0000000000000001 RSI: 0000000000000282 RDI: 00000000ffffffff
> [  196.024901] RBP: ffff8881351dd000 R08: 0000000000024120 R09: ffffffff819a97fe
> [  196.026977] R10: ffffea0004cf6800 R11: 00000000005b8d80 R12: ffffffff81294ec2
> [  196.029119] R13: ffff888134e27b40 R14: ffff88813bb307a0 R15: ffff888133d59910
> [  196.031071] FS:  00007f1a8a8c3740(0000) GS:ffff88813bb00000(0000) knlGS:0000000000000000
> [  196.033069] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  196.034438] CR2: 00007f1a8aba5920 CR3: 000000000260e004 CR4: 00000000003606a0
> [  196.036310] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  196.038399] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [  196.039794] Call Trace:
> [  196.040259]  __sk_destruct+0x1c/0x150
> [  196.040964]  ? io_sqe_files_unregister+0x32/0x70
> [  196.041841]  unix_destruct_scm+0x76/0xa0
> [  196.042587]  skb_release_head_state+0x38/0x60
> [  196.043401]  skb_release_all+0x9/0x20
> [  196.044034]  kfree_skb+0x2d/0xb0
> [  196.044603]  io_sqe_files_unregister+0x32/0x70
> [  196.045385]  io_ring_ctx_wait_and_kill+0xf6/0x1a0
> [  196.046220]  io_uring_release+0x17/0x20
> [  196.046881]  __fput+0x9d/0x1d0
> [  196.047421]  task_work_run+0x7a/0x90
> [  196.048045]  do_exit+0x301/0xc20
> [  196.048626]  ? handle_mm_fault+0xf3/0x230
> [  196.049321]  do_group_exit+0x35/0xa0
> [  196.049944]  __x64_sys_exit_group+0xf/0x10
> [  196.050658]  do_syscall_64+0x3d/0xf0
> [  196.051317]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [  196.052217] RIP: 0033:0x7f1a8aba5956
> [  196.052859] Code: Bad RIP value.
> [  196.053488] RSP: 002b:00007fffbdbcad38 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
> [  196.054902] RAX: ffffffffffffffda RBX: 00007f1a8ac975c0 RCX: 00007f1a8aba5956
> [  196.056124] RDX: 0000000000000000 RSI: 000000000000003c RDI: 0000000000000000
> [  196.057348] RBP: 0000000000000000 R08: 00000000000000e7 R09: ffffffffffffff78
> [  196.058573] R10: 00007fffbdbcabf8 R11: 0000000000000246 R12: 00007f1a8ac975c0
> [  196.059459] R13: 0000000000000001 R14: 00007f1a8aca0288 R15: 0000000000000000
> [  196.060731] ---[ end trace 8a7e42f9199e5f92 ]---
> [  196.062671] WARNING: CPU: 1 PID: 1938 at ../net/unix/af_unix.c:501 unix_sock_destructor+0xa3/0xc0
> [  196.064372] Modules linked in:
> [  196.064966] CPU: 1 PID: 1938 Comm: aio_buffered Tainted: G        W         5.0.0-rc5+ #379
> [  196.066546] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1ubuntu1 04/01/2014
> [  196.068234] RIP: 0010:unix_sock_destructor+0xa3/0xc0
> [  196.068999] Code: c7 c7 6c 5b 9a 81 e9 8c 2a 71 ff 48 89 ef e8 c4 dc 87 ff eb be 0f 0b 48 83 7b 70 00 74 8b 0f 0b 48 83 bb 68 02 00 00 00 74 89 <0f> 0b eb 85 48 89 de 48 c7 c7 a0 c8 42 82 5b 5d e9 31 8c 75 ff 0f
> [  196.072577] RSP: 0018:ffffc900008a7d40 EFLAGS: 00010282
> [  196.073595] RAX: 0000000000000000 RBX: ffff8881351dd000 RCX: 0000000000000000
> [  196.074973] RDX: 0000000000000001 RSI: 0000000000000282 RDI: 00000000ffffffff
> [  196.076348] RBP: ffff8881351dd000 R08: 0000000000024120 R09: ffffffff819a97fe
> [  196.077709] R10: ffffea0004cf6800 R11: 00000000005b8d80 R12: ffffffff81294ec2
> [  196.079072] R13: ffff888134e27b40 R14: ffff88813bb307a0 R15: ffff888133d59910
> [  196.080441] FS:  00007f1a8a8c3740(0000) GS:ffff88813bb00000(0000) knlGS:0000000000000000
> [  196.082026] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  196.083131] CR2: 00007fbc19f96550 CR3: 0000000138d1e003 CR4: 00000000003606a0
> [  196.084505] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  196.085823] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [  196.087185] Call Trace:
> [  196.087662]  __sk_destruct+0x1c/0x150
> [  196.088376]  ? io_sqe_files_unregister+0x32/0x70
> [  196.089299]  unix_destruct_scm+0x76/0xa0
> [  196.090059]  skb_release_head_state+0x38/0x60
> [  196.090929]  skb_release_all+0x9/0x20
> [  196.091550]  kfree_skb+0x2d/0xb0
> [  196.092745]  io_sqe_files_unregister+0x32/0x70
> [  196.093535]  io_ring_ctx_wait_and_kill+0xf6/0x1a0
> [  196.094358]  io_uring_release+0x17/0x20
> [  196.095029]  __fput+0x9d/0x1d0
> [  196.095660]  task_work_run+0x7a/0x90
> [  196.096307]  do_exit+0x301/0xc20
> [  196.096808]  ? handle_mm_fault+0xf3/0x230
> [  196.097504]  do_group_exit+0x35/0xa0
> [  196.098126]  __x64_sys_exit_group+0xf/0x10
> [  196.098836]  do_syscall_64+0x3d/0xf0
> [  196.099460]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [  196.100334] RIP: 0033:0x7f1a8aba5956
> [  196.100958] Code: Bad RIP value.
> [  196.101293] RSP: 002b:00007fffbdbcad38 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
> [  196.101933] RAX: ffffffffffffffda RBX: 00007f1a8ac975c0 RCX: 00007f1a8aba5956
> [  196.102535] RDX: 0000000000000000 RSI: 000000000000003c RDI: 0000000000000000
> [  196.103137] RBP: 0000000000000000 R08: 00000000000000e7 R09: ffffffffffffff78
> [  196.103739] R10: 00007fffbdbcabf8 R11: 0000000000000246 R12: 00007f1a8ac975c0
> [  196.104526] R13: 0000000000000001 R14: 00007f1a8aca0288 R15: 0000000000000000
> [  196.105777] ---[ end trace 8a7e42f9199e5f93 ]---
> [  196.107535] unix: Attempt to release alive unix socket: 000000003b3c1a34
> 
> which corresponds to the WARN_ONs:
> 
> 	WARN_ON(!sk_unhashed(sk));
> 	WARN_ON(sk->sk_socket);
> 
> This doesn't seem to happen if I omit the call to io_uring_register.

Huh, I can't reproduce that here, teardown seems to work just fine. It
looks like the socket is getting torn down prematurely, when we free the
skb. I wonder if you have some networking options I don't? What's your
.config?

-- 
Jens Axboe

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
