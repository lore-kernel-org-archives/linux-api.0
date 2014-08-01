From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH 1/5] Add __designated_init, wrapping
 __attribute__((designated_init))
Date: Fri, 1 Aug 2014 13:45:29 -0700
Message-ID: <20140801134529.40b46e92a48d9bf0c0abc139@linux-foundation.org>
References: <3130b0553b15518e3bef6d14c80280beed0f5ff9.1406850006.git.josh@joshtriplett.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3130b0553b15518e3bef6d14c80280beed0f5ff9.1406850006.git.josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Cc: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Christopher Li <sparse-55XgFHCVCFZAfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, Michal Marek <mmarek-AlSwsSmVLrQ@public.gmane.org>, Neil Brown <neilb-l3A5Bk7waGM@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kbuild-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sparse-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, 31 Jul 2014 16:47:23 -0700 Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org> wrote:

> GCC 4.10 and newer, and Sparse, supports
> __attribute__((designated_init)), which marks a structure as requiring
> a designated initializer rather than a positional one.  This helps
> reduce churn and errors when used with _ops structures and similar
> structures designed for future extension.
> 
> Add a wrapper __designated_init, which turns into
> __attribute__((designated_init)) for Sparse or sufficiently new GCC.
> Enable the corresponding warning as an error.
> 
> The following semantic patch can help mark structures containing
> function pointers as requiring designated initializers:
> 
> @@
> identifier I, f;
> type T;
> @@
> 
> struct I {
> 	...
> 	T (*f)(...);
> 	...
> }
> + __designated_init

hm, dunno about this.

I think that the kernel should always use designated initializers
everywhere.  Perhaps there are a few special cases where positional
initializers provide a superior result but I'm not sure where those
might be.

In which case what we should do is to teach sparse to warn about
positional initializers then go fix them all up (lol).  After that
process is complete, this __designated_init tag would be just noise.

To support this perhaps a sparse tag would be needed which says
"positional initializers are OK here".  This way we're adding the
annotation to the exceptional cases, not to the common cases.
