From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH V6 07/10] sched: add a macro to ref all CLONE_NEW* flags
Date: Fri, 17 Apr 2015 19:41:31 +0200
Message-ID: <20150417174131.GL23123@twins.programming.kicks-ass.net>
References: <cover.1429252659.git.rgb@redhat.com>
	<cf1ed24f71743ea7f85682f26f3185202a1f8a32.1429252659.git.rgb@redhat.com>
	<20150417081843.GE23123@twins.programming.kicks-ass.net>
	<20150417154250.GA26233@madcap2.tricolour.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150417154250.GA26233-bcJWsdo4jJjeVoXN4CMphl7TgLCtbB0G@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Richard Guy Briggs <rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pmoore-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-audit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org, sgrubb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, Apr 17, 2015 at 11:42:50AM -0400, Richard Guy Briggs wrote:
> On 15/04/17, Peter Zijlstra wrote:
> > On Fri, Apr 17, 2015 at 03:35:54AM -0400, Richard Guy Briggs wrote:
> > > Added the macro CLONE_NEW_MASK_ALL to refer to all CLONE_NEW* flags.
> > 
> > A wee bit about why might be nice..
> 
> It makes the following patch much cleaner to read:
> 	[PATCH V6 08/10] fork: audit on creation of new namespace(s)
> 	https://lkml.org/lkml/2015/4/17/50
> 
> I was hoping it might also make a lot of other code cleaner, but most of
> the other places where multiple CLONE_NEW* flags are used, not all six
> are used together, but only 5 are used.  Ok, so it is helpful in 1 of 3:
> 
> It would actually be useful in check_unshare_flags():
> 	https://github.com/torvalds/linux/blob/v3.17/kernel/fork.c#L1791
> 
> but not in copy_namespaces() or unshare_nsproxy_namespaces():
> 	https://github.com/torvalds/linux/blob/v3.17/kernel/nsproxy.c#L130
> 	https://github.com/torvalds/linux/blob/v3.17/kernel/nsproxy.c#L183
> 

Right, so no objections from me on this, its just that I only saw this
one patch in isolation without context and the changelog failed on
rationale.

Does it perchance make sense to fold this patch into the next patch that
actually makes use of it?
