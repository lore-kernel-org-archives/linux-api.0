From: Sukadev Bhattiprolu <sukadev-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [RFC][v8][PATCH 0/10] Implement clone3() system call
Date: Wed, 14 Oct 2009 17:17:39 -0700
Message-ID: <20091015001739.GC3515@us.ibm.com>
References: <20091013044925.GA28181@us.ibm.com>
	<20091013205015.1ED524F7@magilla.sf.frob.com>
	<20091013232736.GA24392@us.ibm.com>
	<20091013235320.E90022746@magilla.sf.frob.com>
	<4AD525B3.2070906@zytor.com> <20091014223634.GB3515@us.ibm.com>
	<4AD6557D.3090501@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4AD6557D.3090501-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.linux-foundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linux-foundation.org/pipermail/containers>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linux-foundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: randy.dunlap-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Nathan Lynch <nathanl-V7BBcbaFuwjMbYB6QlFGEg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Louis.Rilling-aw0BnHfMbSpBDgjK7y7TUQ@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mingo-X9Un+BFzKDI@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roland McGrath <roland-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Pavel Emelyanov <xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

H. Peter Anvin [hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org] wrote:
| On 10/14/2009 03:36 PM, Sukadev Bhattiprolu wrote:
| > H. Peter Anvin [hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org] wrote:
| > | 
| > | Overall it seems sane to:
| > | 
| > | a) make it an actual 3-argument call;
| > | b) make the existing flags a u32 forever, and make it a separate
| > |    argument;
| > | c) any new expansion can be via the struct, which may want to have
| > |    an "c3_flags" field first in the structure.
| > 
| > Ok, So will this work ?
| > 
| > 	struct clone_args {
| > 		u32 flags_high;		/* new clone flags (higher bits) */ 
| > 		u32 reserved1;
| > 		u32 nr_pids;
| > 		u32 reserved2;
| > 		u64 child_stack_base;
| > 		u64 child_stack_size;
| > 		u64 parent_tid_ptr;
| > 		u64 child_tid_ptr;
| > 		u64 reserved3;
| > 	};
| > 
| > 	sys_clone3(u32 flags_low, struct clone_args *args, pid_t *pid_list)
| > 
| > Even on 64bit architectures the applications have to use sys_clone3() for
| > the extended features.
| 
| Yes, although I'd just make flags_high a u64.

so we allow 96 bits for flags ?

| The other thing that might be worthwhile is to have a length field on
| the structure; that way we could add new fields at the end if ever
| necessary in the future.

So:
	struct clone_args {
		u64 flags_high;		/* new clone flags (higher bits) */ 
		u64 reserved1;

		u32 nr_pids;
		u32 clone_args_size;

		u64 child_stack_base;
		u64 child_stack_size;

		u64 parent_tid_ptr;
		u64 child_tid_ptr;
	};

	sys_clone3(u32 flags_low, struct clone_args *args, pid_t *pid_list)

BTW, on 64-bit architectures, the flags_low would be 64-bits, but the high-
bits there would be ignored right ?

Not sure if we need a second reserved field now that we add ->clone_args_size.

Thanks,

Sukadev
