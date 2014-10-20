From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] staging: android: binder: move to the "real" part of the
 kernel
Date: Mon, 20 Oct 2014 12:20:49 +0300
Message-ID: <20141020092049.GJ23154@mwanda>
References: <20141016124741.GA3832@kroah.com> <20141017092601.GH23154@mwanda>
 <20141019220547.GC3780@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <20141019220547.GC3780@kroah.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, Anup Patel <anup.patel@linaro.org>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>, John Stultz <john.stultz@linaro.org>, Rebecca Schultz Zavin <rebecca@android.com>, Santosh Shilimkar <santosh.shilimkar@ti.com>, Sumit Semwal <sumit.semwal@linaro.org>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: linux-api@vger.kernel.org

On Mon, Oct 20, 2014 at 06:05:47AM +0800, Greg Kroah-Hartman wrote:
> On Fri, Oct 17, 2014 at 12:26:01PM +0300, Dan Carpenter wrote:
> > The code isn't very beautiful and there are lots of details wrong like
> > the error codes.
> 
> Really, what is wrong with the existing error code usages?
> 

I guess I was mostly looking at binder_ioctl(), the rest of the code
seems better.

I feel like we went directly from "This code is never going in so there
is no need to look at it." to "This code is going in in one week so
there is no time to look at it."

How often do people rely on proc_no_lock=1 to make this work?  People
are saying on the internet that you don't need acurate information so
you should disable locking as a speed up.
http://www.programdevelop.com/1821706/.  It seems like a bad idea to
provide provide the "run fast and crash" option.

Why is binder_set_nice needed?  Some comments would help here.

   434  static void binder_set_nice(long nice)
   435  {
   436          long min_nice;
   437  
   438          if (can_nice(current, nice)) {
   439                  set_user_nice(current, nice);
   440                  return;
   441          }
   442          min_nice = rlimit_to_nice(current->signal->rlim[RLIMIT_NICE].rlim_cur);
   443          binder_debug(BINDER_DEBUG_PRIORITY_CAP,
   444                       "%d: nice value %ld not allowed use %ld instead\n",
   445                        current->pid, nice, min_nice);
   446          set_user_nice(current, min_nice);
   447          if (min_nice <= MAX_NICE)
   448                  return;

It's harmless but wierd to check if min_nice is valid after we already
called set_user_nice().

   449          binder_user_error("%d RLIMIT_NICE not set\n", current->pid);
   450  }

Random comment:

   709          has_page_addr =
   710                  (void *)(((uintptr_t)buffer->data + buffer_size) & PAGE_MASK);

The casting on "buffer->data" ugly and inconsistent.  There should be
a function:
void *buffer_data(struct binder_buffer *buffer)
{
	return buffer.data;
}

That way this becomes:
		has_page_addr = (buffer_data(buffer) + buffer_size) & PAGE_MASK);

The "has_page_addr" variable name is misleading, because we're not
storing true/false.  We're storing the last page address.

   711          if (n == NULL) {
   712                  if (size + sizeof(struct binder_buffer) + 4 >= buffer_size)
   713                          buffer_size = size; /* no room for other buffers */
   714                  else
   715                          buffer_size = size + sizeof(struct binder_buffer);
   716          }
   717          end_page_addr =
   718                  (void *)PAGE_ALIGN((uintptr_t)buffer->data + buffer_size);
   719          if (end_page_addr > has_page_addr)
   720                  end_page_addr = has_page_addr;
   721          if (binder_update_page_range(proc, 1,
   722              (void *)PAGE_ALIGN((uintptr_t)buffer->data), end_page_addr, NULL))
   723                  return NULL;

The alignment here is confusing because we don't align buffer->data
below.

   724  
   725          rb_erase(best_fit, &proc->free_buffers);
   726          buffer->free = 0;
   727          binder_insert_allocated_buffer(proc, buffer);
   728          if (buffer_size != size) {
   729                  struct binder_buffer *new_buffer = (void *)buffer->data + size;
                                                           ^^^^^^^^^^^^^^^^^^^^
I don't really understand when buffer->data has to be page aligned and
when not.  This code has very few comments.

   730  
   731                  list_add(&new_buffer->entry, &buffer->entry);
   732                  new_buffer->free = 1;
   733                  binder_insert_free_buffer(proc, new_buffer);
   734          }

Does the stop_on_user_error option work?  There should be some
documentation for this stuff.

regards,
dan carpenter
