From: josh@joshtriplett.org
Subject: Re: [PATCH 1/5] Add __designated_init, wrapping
 __attribute__((designated_init))
Date: Fri, 1 Aug 2014 14:36:17 -0700
Message-ID: <20140801213617.GB20310@cloud>
References: <3130b0553b15518e3bef6d14c80280beed0f5ff9.1406850006.git.josh@joshtriplett.org>
 <20140801134529.40b46e92a48d9bf0c0abc139@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kbuild-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140801134529.40b46e92a48d9bf0c0abc139@linux-foundation.org>
Sender: linux-kbuild-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Christopher Li <sparse@chrisli.org>, Ingo Molnar <mingo@redhat.com>, Jeff Layton <jlayton@poochiereds.net>, Michal Marek <mmarek@suse.cz>, Neil Brown <neilb@suse.de>, Steven Rostedt <rostedt@goodmis.org>, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-sparse@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, Aug 01, 2014 at 01:45:29PM -0700, Andrew Morton wrote:
> On Thu, 31 Jul 2014 16:47:23 -0700 Josh Triplett <josh@joshtriplett.org> wrote:
> 
> > GCC 4.10 and newer, and Sparse, supports
> > __attribute__((designated_init)), which marks a structure as requiring
> > a designated initializer rather than a positional one.  This helps
> > reduce churn and errors when used with _ops structures and similar
> > structures designed for future extension.
> > 
> > Add a wrapper __designated_init, which turns into
> > __attribute__((designated_init)) for Sparse or sufficiently new GCC.
> > Enable the corresponding warning as an error.
> > 
> > The following semantic patch can help mark structures containing
> > function pointers as requiring designated initializers:
> > 
> > @@
> > identifier I, f;
> > type T;
> > @@
> > 
> > struct I {
> > 	...
> > 	T (*f)(...);
> > 	...
> > }
> > + __designated_init
> 
> hm, dunno about this.
> 
> I think that the kernel should always use designated initializers
> everywhere.  Perhaps there are a few special cases where positional
> initializers provide a superior result but I'm not sure where those
> might be.
> 
> In which case what we should do is to teach sparse to warn about
> positional initializers then go fix them all up (lol).  After that
> process is complete, this __designated_init tag would be just noise.
> 
> To support this perhaps a sparse tag would be needed which says
> "positional initializers are OK here".  This way we're adding the
> annotation to the exceptional cases, not to the common cases.

Before submitting this series, I actually used coccinelle to
automatically add __designated_init to nearly a thousand structures
(just in include/linux/ alone), and did a build with that.  Even just
adding it to structures with function pointers, some cases produce a
*huge* number of warnings.  I think it might make sense to work our way
through those warnings, but "go fix them all up" would be a gargantuan
effort.  (For an idea of scale: there were more warnings about
positional initialization than everything other warning combined, by a
substantial factor, and that's just from changing a few hundred
structures.)

I'm not at all convinced that we want to universally enforce designated
initializers *yet*.  They make sense for _ops structures and other
structures that contain function pointers (which is a small subset), but
for many other structures they just add a large amount of noise to
initialization.  If we could say "automatically add __designated_init to
structures matching these criteria", that could work, but "all
structures" not so much.  (For instance, a structure with a single
field, or two fields of incompatible types with an intuitive ordering,
doesn't gain much value from designated initialization.)

Now, some cases may make sense to fix despite the large volume.  For
instance, many users of dmi_system_id initialize it positionally, and
shouldn't; I've already written patches for quite a few of them, with
many more to go.  But, for instance, obs_kernel_param seems much less
worthwhile to fix, because we shouldn't add any new instances of it, and
we likely won't ever extend it.  The value in fixing this issue mostly
comes not with the current code, but with future changes to the
structure.  (And, as always happens with this kind of change, we'll end
up with a few holdouts who don't want to change their code, which will
stop us from eliminating the warning completely.)

In the course of introducing this change, we'll end up fixing a large
number of positional init warnings.  If in the course of doing so, it
starts making sense to enforce it everywhere, it seems easy enough to
sed away all the __designated_init tags.  But in terms of noise, the
actual additions of __designated_init will pale in comparison to the
patches fixing positional initializers.

Finally, by migrating over to this incrementally, structure by
structure, we can safely make the warning an error, which we could not
do if we applied it to every struct immediately.

- Josh Triplett
