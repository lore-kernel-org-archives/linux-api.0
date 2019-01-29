From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 12/18] io_uring: add support for pre-mapped user IO
 buffers
Date: Tue, 29 Jan 2019 16:14:56 -0700
Message-ID: <379a631f-e55b-cc31-f84a-ace73fd66ea1@kernel.dk>
References: <20190129192702.3605-1-axboe@kernel.dk>
 <20190129192702.3605-13-axboe@kernel.dk>
 <CAG48ez2VkeSEZA+9H4UAcg86uC77gU=UkTG8L1V58TuR9pDEqg@mail.gmail.com>
 <dd366179-c003-752f-743d-2bea4f6b796c@kernel.dk>
 <CAG48ez3x5x+P=8L1p-bHvcUnypeT1TizkXq2+Q0bCP0GdE-bog@mail.gmail.com>
 <87b25ce2-a5bc-3e81-ddba-5c932c71b40f@kernel.dk>
 <CAG48ez1m22z0Pqi0cT=UZdsA14SCM5579T1d40cZdyD6KqBw_g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <CAG48ez1m22z0Pqi0cT=UZdsA14SCM5579T1d40cZdyD6KqBw_g@mail.gmail.com>
Content-Language: en-US
Sender: owner-linux-aio@kvack.org
To: Jann Horn <jannh@google.com>
Cc: linux-aio@kvack.org, linux-block@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, hch@lst.de, jmoyer@redhat.com, Avi Kivity <avi@scylladb.com>
List-Id: linux-api@vger.kernel.org

On 1/29/19 4:08 PM, Jann Horn wrote:
> On Wed, Jan 30, 2019 at 12:06 AM Jens Axboe <axboe@kernel.dk> wrote:
>> On 1/29/19 4:03 PM, Jann Horn wrote:
>>> On Tue, Jan 29, 2019 at 11:56 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>> On 1/29/19 3:44 PM, Jann Horn wrote:
>>>>> On Tue, Jan 29, 2019 at 8:27 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>>> If we have fixed user buffers, we can map them into the kernel when we
>>>>>> setup the io_context. That avoids the need to do get_user_pages() for
>>>>>> each and every IO.
>>>>>>
>>>>>> To utilize this feature, the application must call io_uring_register()
>>>>>> after having setup an io_uring context, passing in
>>>>>> IORING_REGISTER_BUFFERS as the opcode. The argument must be a pointer
>>>>>> to an iovec array, and the nr_args should contain how many iovecs the
>>>>>> application wishes to map.
>>>>>>
>>>>>> If successful, these buffers are now mapped into the kernel, eligible
>>>>>> for IO. To use these fixed buffers, the application must use the
>>>>>> IORING_OP_READ_FIXED and IORING_OP_WRITE_FIXED opcodes, and then
>>>>>> set sqe->index to the desired buffer index. sqe->addr..sqe->addr+seq->len
>>>>>> must point to somewhere inside the indexed buffer.
>>>>>>
>>>>>> The application may register buffers throughout the lifetime of the
>>>>>> io_uring context. It can call io_uring_register() with
>>>>>> IORING_UNREGISTER_BUFFERS as the opcode to unregister the current set of
>>>>>> buffers, and then register a new set. The application need not
>>>>>> unregister buffers explicitly before shutting down the io_uring context.
>>> [...]
>>>>>> +       imu = &ctx->user_bufs[index];
>>>>>> +       buf_addr = READ_ONCE(sqe->addr);
>>>>>> +       if (buf_addr < imu->ubuf || buf_addr + len > imu->ubuf + imu->len)
>>>>>
>>>>> This can wrap around if `buf_addr` or `len` is very big, right? Then
>>>>> you e.g. get past the first check because `buf_addr` is sufficiently
>>>>> big, and get past the second check because `buf_addr + len` wraps
>>>>> around and becomes small.
>>>>
>>>> Good point. I wonder if we have a verification helper for something like
>>>> this?
>>>
>>> check_add_overflow() exists, I guess that might help a bit. I don't
>>> think I've seen a more specific helper for this situation.
>>
>> Hmm, not super appropriate. How about something ala:
>>
>> if (buf_addr + len < buf_addr)
>>     ... overflow ...
>>
>> ?
> 
> Sure, sounds good.

Just folded in this incremental, which should fix all the issues outlined
in your email.


diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7364feebafed..d42541357969 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -751,7 +751,7 @@ static int io_import_fixed(struct io_ring_ctx *ctx, int rw,
 {
 	size_t len = READ_ONCE(sqe->len);
 	struct io_mapped_ubuf *imu;
-	int buf_index, index;
+	unsigned index, buf_index;
 	size_t offset;
 	u64 buf_addr;
 
@@ -763,9 +763,12 @@ static int io_import_fixed(struct io_ring_ctx *ctx, int rw,
 	if (unlikely(buf_index >= ctx->nr_user_bufs))
 		return -EFAULT;
 
-	index = array_index_nospec(buf_index, ctx->sq_entries);
+	index = array_index_nospec(buf_index, ctx->nr_user_bufs);
 	imu = &ctx->user_bufs[index];
 	buf_addr = READ_ONCE(sqe->addr);
+
+	if (buf_addr + len < buf_addr)
+		return -EFAULT;
 	if (buf_addr < imu->ubuf || buf_addr + len > imu->ubuf + imu->len)
 		return -EFAULT;
 
@@ -1602,6 +1605,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, struct sqe_submit *sqes,
 
 static int io_sq_thread(void *data)
 {
+	struct io_uring_sqe lsqe[IO_IOPOLL_BATCH];
 	struct sqe_submit sqes[IO_IOPOLL_BATCH];
 	struct io_ring_ctx *ctx = data;
 	struct mm_struct *cur_mm = NULL;
@@ -1701,6 +1705,14 @@ static int io_sq_thread(void *data)
 		i = 0;
 		all_fixed = true;
 		do {
+			/*
+			 * Ensure sqe is stable between checking if we need
+			 * user access, and actually importing the iovec
+			 * further down the stack.
+			 */
+			memcpy(&lsqe[i], sqes[i].sqe, sizeof(lsqe[i]));
+			sqes[i].sqe = &lsqe[i];
+
 			if (all_fixed && io_sqe_needs_user(sqes[i].sqe))
 				all_fixed = false;
 
@@ -2081,7 +2093,7 @@ static int io_copy_iov(struct io_ring_ctx *ctx, struct iovec *dst,
 	struct iovec __user *src;
 
 #ifdef CONFIG_COMPAT
-	if (in_compat_syscall()) {
+	if (ctx->compat) {
 		struct compat_iovec __user *ciovs;
 		struct compat_iovec ciov;
 
@@ -2103,7 +2115,6 @@ static int io_copy_iov(struct io_ring_ctx *ctx, struct iovec *dst,
 static int io_sqe_buffer_register(struct io_ring_ctx *ctx, void __user *arg,
 				  unsigned nr_args)
 {
-	struct vm_area_struct **vmas = NULL;
 	struct page **pages = NULL;
 	int i, j, got_pages = 0;
 	int ret = -EINVAL;
@@ -2138,7 +2149,7 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, void __user *arg,
 		 * submitted if they are wrong.
 		 */
 		ret = -EFAULT;
-		if (!iov.iov_base)
+		if (!iov.iov_base || !iov.iov_len)
 			goto err;
 
 		/* arbitrary limit, but we need something */
@@ -2155,14 +2166,10 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, void __user *arg,
 			goto err;
 
 		if (!pages || nr_pages > got_pages) {
-			kfree(vmas);
 			kfree(pages);
 			pages = kmalloc_array(nr_pages, sizeof(struct page *),
 						GFP_KERNEL);
-			vmas = kmalloc_array(nr_pages,
-					sizeof(struct vma_area_struct *),
-					GFP_KERNEL);
-			if (!pages || !vmas) {
+			if (!pages) {
 				io_unaccount_mem(ctx, nr_pages);
 				goto err;
 			}
@@ -2176,32 +2183,18 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, void __user *arg,
 			goto err;
 		}
 
-		down_write(&current->mm->mmap_sem);
-		pret = get_user_pages_longterm(ubuf, nr_pages, FOLL_WRITE,
-						pages, vmas);
-		if (pret == nr_pages) {
-			/* don't support file backed memory */
-			for (j = 0; j < nr_pages; j++) {
-				struct vm_area_struct *vma = vmas[j];
+		down_read(&current->mm->mmap_sem);
+		pret = get_user_pages_longterm(ubuf, nr_pages,
+						FOLL_WRITE | FOLL_ANON, pages,
+						NULL);
+		up_read(&current->mm->mmap_sem);
 
-				if (vma->vm_file) {
-					ret = -EOPNOTSUPP;
-					break;
-				}
-			}
-		} else {
-			ret = pret < 0 ? pret : -EFAULT;
-		}
-		up_write(&current->mm->mmap_sem);
-		if (ret) {
-			/*
-			 * if we did partial map, or found file backed vmas,
-			 * release any pages we did get
-			 */
+		if (pret != nr_pages) {
 			if (pret > 0) {
 				for (j = 0; j < pret; j++)
 					put_page(pages[j]);
 			}
+			ret = pret < 0 ? pret : -EFAULT;
 			io_unaccount_mem(ctx, nr_pages);
 			goto err;
 		}
@@ -2224,12 +2217,10 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, void __user *arg,
 		imu->nr_bvecs = nr_pages;
 	}
 	kfree(pages);
-	kfree(vmas);
 	ctx->nr_user_bufs = nr_args;
 	return 0;
 err:
 	kfree(pages);
-	kfree(vmas);
 	io_sqe_buffer_unregister(ctx);
 	return ret;
 }

-- 
Jens Axboe

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
