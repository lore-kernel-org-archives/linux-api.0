From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [REVIEW][PATCH 03/11] msg/security: Pass kern_ipc_perm not
	msg_queue into the msg_queue security hooks
Date: Sat, 24 Mar 2018 00:37:19 -0500
Message-ID: <87efkam3u8.fsf@xmission.com>
References: <87vadmobdw.fsf_-_@xmission.com>
	<20180323191614.32489-3-ebiederm@xmission.com>
	<bb73b0ea-bcda-a996-8f14-48d9dd1b0940@schaufler-ca.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <bb73b0ea-bcda-a996-8f14-48d9dd1b0940-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org> (Casey
	Schaufler's message of "Fri, 23 Mar 2018 14:55:09 -0700")
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>
Cc: esyr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, prakash.sangappa-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Nagarathnam Muthusamy <nagarathnam.muthusamy-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Pavel Emelyanov <xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org> writes:

> On 3/23/2018 12:16 PM, Eric W. Biederman wrote:
>> All of the implementations of security hooks that take msg_queue only
>> access q_perm the struct kern_ipc_perm member.  This means the
>> dependencies of the msg_queue security hooks can be simplified by
>> passing the kern_ipc_perm member of msg_queue.
>>
>> Making this change will allow struct msg_queue to become private to
>> ipc/msg.c.
>>
>> Signed-off-by: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
>> ---
>>  include/linux/lsm_hooks.h  | 12 ++++++------
>>  include/linux/security.h   | 25 ++++++++++++-------------
>>  ipc/msg.c                  | 18 ++++++++----------
>>  security/security.c        | 12 ++++++------
>>  security/selinux/hooks.c   | 36 ++++++++++++++++++------------------
>>  security/smack/smack_lsm.c | 24 ++++++++++++------------
>
> Can I reference the comments I made in PATCH 01 of this set
> regarding the Smack changes? The problem in all of your changes
> is the same. You aren't preserving the naming conventions, and
> you've left in some code that is just silly.

Being silly like that is actually important to make a sweeping patch
like that boring and trivial to show that it is correct.  Anything
that is not a rule based transformation is much more likely to hide
a bug.  So for the push down of the type change I think it was the right
way to go.

That said I am happy to add a clean up patch that makes the obvious
cleanups and simplifications to smack_lsm.c.

Eric
