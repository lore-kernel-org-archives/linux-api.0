From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 12/18] io_uring: add support for pre-mapped user IO
 buffers
Date: Thu, 7 Feb 2019 14:02:46 -0700
Message-ID: <0a382a3f-d277-21d2-e62f-b2c41b3c441a@kernel.dk>
References: <20190207195552.22770-1-axboe@kernel.dk>
 <20190207195552.22770-13-axboe@kernel.dk>
 <x49mun75nam.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <x49mun75nam.fsf@segfault.boston.devel.redhat.com>
Content-Language: en-US
Sender: owner-linux-aio@kvack.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-aio@kvack.org, linux-block@vger.kernel.org, linux-api@vger.kernel.org, hch@lst.de, avi@scylladb.com, jannh@google.com, viro@ZenIV.linux.org.uk
List-Id: linux-api@vger.kernel.org

On 2/7/19 1:57 PM, Jeff Moyer wrote:
> Hi, Jens,
> 
> Jens Axboe <axboe@kernel.dk> writes:
> 
>> +static int io_sqe_buffer_unregister(struct io_ring_ctx *ctx)
>> +{
>> +	int i, j;
>> +
>> +	if (!ctx->user_bufs)
>> +		return -ENXIO;
>> +
>> +	for (i = 0; i < ctx->sq_entries; i++) {
>> +		struct io_mapped_ubuf *imu = &ctx->user_bufs[i];
>> +
>> +		for (j = 0; j < imu->nr_bvecs; j++)
>> +			put_page(imu->bvec[j].bv_page);
>> +
>> +		io_unaccount_mem(ctx->user, imu->nr_bvecs);
>> +		kfree(imu->bvec);
>> +		imu->nr_bvecs = 0;
>> +	}
>> +
>> +	kfree(ctx->user_bufs);
>> +	ctx->user_bufs = NULL;
>> +	free_uid(ctx->user);
>         ^^^^^^^^^^^^^^^^^^^
>> +	ctx->user = NULL;
>         ^^^^^^^^^^^^^^^^^
> 
> I don't think you want to do that here.  If you do an
> IORING_REGISTER_BUFFERS, followed by IORING_UNREGISTER_BUFFERS, and then
> follow that up with IORING_REGISTER_FILES, you'll get a null pointer
> dereference trying to bump the reference count of the (now NULL)
> ctx->user (io_uring.c:1944):
> 
> [  216.927990] BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
> [  216.935825] #PF error: [WRITE]
> [  216.938883] PGD 5f39244067 P4D 5f39244067 PUD 5f043ca067 PMD 0 
> [  216.944803] Oops: 0002 [#1] SMP
> [  216.947949] CPU: 79 PID: 3371 Comm: io_uring_regist Not tainted 5.0.0-rc5.io_uring.4+ #26
> [  216.956119] Hardware name: Intel Corporation S2600WFD/S2600WFD, BIOS SE5C620.86B.0D.01.0108.091420182119 09/14/2018
> [  216.966553] RIP: 0010:__io_uring_register+0x1c2/0x7c0
> [  216.971606] Code: 49 89 c6 48 85 c0 0f 84 9b 05 00 00 48 8b 83 20 02 00 00 48 8b 40 20 49 c7 46 60 60 89 1d 96 49 89 46 18 48 8b 83 18 01 00 00 <f0> ff 00 0f 88 1a a0 52 00 45 31 e4 66 83 7d 00 00 48 89 45 08 7e
> [  216.990355] RSP: 0018:ffffb296087e3e70 EFLAGS: 00010286
> [  216.995578] RAX: 0000000000000000 RBX: ffff9aacbbff3800 RCX: 0000000000000000
> [  217.002711] RDX: ffff9aacbbaf1ac0 RSI: 00000000ffffffff RDI: ffff9aacb9a8f6b0
> [  217.009842] RBP: ffff9aacbb45e800 R08: 00000000000000c0 R09: ffff9a4e87c07000
> [  217.016977] R10: 0000000000000006 R11: ffff9aac97da9b00 R12: 00007efdc3dbd1fc
> [  217.024107] R13: ffff9aacbb45ec08 R14: ffff9aacb9a8f600 R15: ffff9aac97da9a00
> [  217.031241] FS:  00007f01c439e500(0000) GS:ffff9aacbf7c0000(0000) knlGS:0000000000000000
> [  217.039326] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  217.045075] CR2: 0000000000000000 CR3: 0000005f08d85002 CR4: 00000000007606e0
> [  217.052207] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  217.059340] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [  217.066472] PKRU: 55555554
> [  217.069183] Call Trace:
> [  217.071638]  __x64_sys_io_uring_register+0x91/0xb0
> [  217.076433]  do_syscall_64+0x4f/0x190
> [  217.080110]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [  217.085167] RIP: 0033:0x7f01c3eb42bd
> [  217.088743] Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 9b 6b 2c 00 f7 d8 64 89 01 48
> 
> I'd expect ctx->user to live as long as the io_uring context itself,
> right?

Yes, it used to just be used for the buffers, now we use it generally. I've
fixed that up, thanks Jeff!

-- 
Jens Axboe

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
