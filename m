From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH v2] usercopy: Avoid soft lockups in test_check_nonzero_user()
Date: Thu, 17 Oct 2019 09:00:48 +1100
Message-ID: <871rvctkof.fsf@mpe.ellerman.id.au>
References: <20191011022447.24249-1-mpe@ellerman.id.au> <20191016122732.13467-1-mpe@ellerman.id.au> <20191016130319.vcc2mqac3ta5jjat@wittgenstein>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191016130319.vcc2mqac3ta5jjat@wittgenstein>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian.brauner@ubuntu.com>
Cc: cyphar@cyphar.com, mingo@redhat.com, peterz@infradead.org, alexander.shishkin@linux.intel.com, jolsa@redhat.com, namhyung@kernel.org, christian@brauner.io, keescook@chromium.org, linux@rasmusvillemoes.dk, viro@zeniv.linux.org.uk, torvalds@linux-foundation.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Christian Brauner <christian.brauner@ubuntu.com> writes:
> On Wed, Oct 16, 2019 at 11:27:32PM +1100, Michael Ellerman wrote:
>> On a machine with a 64K PAGE_SIZE, the nested for loops in
>> test_check_nonzero_user() can lead to soft lockups, eg:
>> 
>>   watchdog: BUG: soft lockup - CPU#4 stuck for 22s! [modprobe:611]
>>   Modules linked in: test_user_copy(+) vmx_crypto gf128mul crc32c_vpmsum virtio_balloon ip_tables x_tables autofs4
>>   CPU: 4 PID: 611 Comm: modprobe Tainted: G             L    5.4.0-rc1-gcc-8.2.0-00001-gf5a1a536fa14-dirty #1151
>>   ...
>>   NIP __might_sleep+0x20/0xc0
>>   LR  __might_fault+0x40/0x60
>>   Call Trace:
>>     check_zeroed_user+0x12c/0x200
>>     test_user_copy_init+0x67c/0x1210 [test_user_copy]
>>     do_one_initcall+0x60/0x340
>>     do_init_module+0x7c/0x2f0
>>     load_module+0x2d94/0x30e0
>>     __do_sys_finit_module+0xc8/0x150
>>     system_call+0x5c/0x68
>> 
>> Even with a 4K PAGE_SIZE the test takes multiple seconds. Instead
>> tweak it to only scan a 1024 byte region, but make it cross the
>> page boundary.
>> 
>> Fixes: f5a1a536fa14 ("lib: introduce copy_struct_from_user() helper")
>> Suggested-by: Aleksa Sarai <cyphar@cyphar.com>
>> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
>
> With Aleksa's Reviewed-by I've picked this up:
> https://git.kernel.org/pub/scm/linux/kernel/git/brauner/linux.git/log/?h=copy_struct_from_user

Thanks. Are you planning to send that to Linus for v5.4 or v5.5 ?

cheers
