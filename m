From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH] usercopy: Avoid soft lockups in test_check_nonzero_user()
Date: Sat, 12 Oct 2019 20:54:51 +1100
Message-ID: <87tv8euw44.fsf@mpe.ellerman.id.au>
References: <20191010114007.o3bygjf4jlfk242e@yavin.dot.cyphar.com> <20191011022447.24249-1-mpe@ellerman.id.au> <20191011034810.xkmz3e4l5ezxvq57@yavin.dot.cyphar.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191011034810.xkmz3e4l5ezxvq57@yavin.dot.cyphar.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: mingo@redhat.com, peterz@infradead.org, alexander.shishkin@linux.intel.com, jolsa@redhat.com, namhyung@kernel.org, christian@brauner.io, keescook@chromium.org, linux@rasmusvillemoes.dk, viro@zeniv.linux.org.uk, torvalds@linux-foundation.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Aleksa Sarai <cyphar@cyphar.com> writes:
> On 2019-10-11, Michael Ellerman <mpe@ellerman.id.au> wrote:
>> On a machine with a 64K PAGE_SIZE, the nested for loops in
>> test_check_nonzero_user() can lead to soft lockups, eg:
...
>> diff --git a/lib/test_user_copy.c b/lib/test_user_copy.c
>> index 950ee88cd6ac..9fb6bc609d4c 100644
>> --- a/lib/test_user_copy.c
>> +++ b/lib/test_user_copy.c
>> @@ -47,9 +47,26 @@ static bool is_zeroed(void *from, size_t size)
>>  static int test_check_nonzero_user(char *kmem, char __user *umem, size_t size)
>>  {
>>  	int ret = 0;
>> -	size_t start, end, i;
>> -	size_t zero_start = size / 4;
>> -	size_t zero_end = size - zero_start;
>> +	size_t start, end, i, zero_start, zero_end;
>> +
>> +	if (test(size < 1024, "buffer too small"))
>> +		return -EINVAL;
>> +
>> +	/*
>> +	 * We want to cross a page boundary to exercise the code more
>> +	 * effectively. We assume the buffer we're passed has a page boundary at
>> +	 * size / 2. We also don't want to make the size we scan too large,
>> +	 * otherwise the test can take a long time and cause soft lockups. So
>> +	 * scan a 1024 byte region across the page boundary.
>> +	 */
>> +	start = size / 2 - 512;
>> +	size = 1024;
>
> I don't think it's necessary to do "size / 2" here -- you can just use
> PAGE_SIZE directly and check above that "size == 2*PAGE_SIZE" (not that
> this check is exceptionally necessary -- since there's only one caller
> of this function and it's in the same file).

OK, like this?

diff --git a/lib/test_user_copy.c b/lib/test_user_copy.c
index 950ee88cd6ac..48bc669b2549 100644
--- a/lib/test_user_copy.c
+++ b/lib/test_user_copy.c
@@ -47,9 +47,25 @@ static bool is_zeroed(void *from, size_t size)
 static int test_check_nonzero_user(char *kmem, char __user *umem, size_t size)
 {
 	int ret = 0;
-	size_t start, end, i;
-	size_t zero_start = size / 4;
-	size_t zero_end = size - zero_start;
+	size_t start, end, i, zero_start, zero_end;
+
+	if (test(size < 2 * PAGE_SIZE, "buffer too small"))
+		return -EINVAL;
+
+	/*
+	 * We want to cross a page boundary to exercise the code more
+	 * effectively. We also don't want to make the size we scan too large,
+	 * otherwise the test can take a long time and cause soft lockups. So
+	 * scan a 1024 byte region across the page boundary.
+	 */
+	size = 1024;
+	start = PAGE_SIZE - (size / 2);
+
+	kmem += start;
+	umem += start;
+
+	zero_start = size / 4;
+	zero_end = size - zero_start;
 
 	/*
 	 * We conduct a series of check_nonzero_user() tests on a block of memory

cheers
