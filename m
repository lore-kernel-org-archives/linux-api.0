From: Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>
Subject: Re: [PATCH RFC v2 1/3] LSM: Allow per LSM module per "struct
 task_struct" blob.
Date: Mon, 10 Apr 2017 12:26:12 -0700
Message-ID: <2698e97b-397e-0fc0-84a1-dc9a4226117a@schaufler-ca.com>
References: <1491734530-25002-1-git-send-email-tixxdz@gmail.com>
 <1491734530-25002-2-git-send-email-tixxdz@gmail.com>
 <f25edeb6-35e1-2f8c-8fd6-fd051c4e79ce@schaufler-ca.com>
 <CAEiveUeHedQAsjbS5Jj9imq28af0OuKAjMTudMJm7GqObRNMfQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAEiveUeHedQAsjbS5Jj9imq28af0OuKAjMTudMJm7GqObRNMfQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org, LSM List <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dongsu Park <dpark-VwIFZPTo/vqsTnJN9+BGXg@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 4/10/2017 11:30 AM, Djalal Harouni wrote:
> On Mon, Apr 10, 2017 at 5:50 PM, Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org> wrote:
>> On 4/9/2017 3:42 AM, Djalal Harouni wrote:
>>> From: Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
>>>
>>> Since several modules are planning to use per "struct task_struct" blob,
>>> we need a layer for isolating it. Therefore, this patch introduces per LSM
>>> module per "struct task_struct" blob.
>>>
>>> It would be possible to remember location in security_hook_heads.task_alloc
>>> list and undo up to the corresponding security_hook_heads.task_free list
>>> when task_alloc hook failed. But this patch calls all task_free hooks
>>> without checking whether the corresponding task_alloc hook was called
>>> since most modules should be able to handle this correctly.
>>>
>>> How to calculate amount of needed bytes and allocate memory for initial
>>> task is a chicken-or-egg syndrome. We need to know how many bytes needs
>>> to be allocated for initial task's security blobs before security_init()
>>> is called. But security_reserve_task_blob_index() which calculates amount
>>> of needed bytes is called from security_init(). We will need to split
>>> module registration into three steps. The first step is call
>>> security_reserve_task_blob_index() on all modules which should be
>>> activated. The second step is allocate memory for the initial task's
>>> security blob. The third step is actually activate all modules which
>>> should be activated.
>>>
>>> Signed-off-by: Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>> Signed-off-by: Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
>> While I appreciate your enthusiasm, I would really like
>> to see a mechanism for managing all of the blobs as being
>> potentially shared rather than just the task blob. With
>> infrastructure blob management being the general case we
>> could stack any set of existing modules that does not
>> include both SELinux and Smack. (AppArmor is threatening
>> to join that set, but we're still waiting on that) I
> Yes! most of the other kernel maintainers I discussed the feature with
> did not even believe or knew that LSM stacking is possible! Some other
> kernel frameworks are being replaced with new ones (I'm not sure if
> the old ones were perfect!)... but what I'm trying to say is that we
> should make it easy for dynamic LSM plugins model so they can explore
> the interface, and maybe after some time the whole framework will even
> be replaced with a better one...

I'm not committing to dynamic modules, but I am working
to make sure I don't do anything to prevent someone else
from doing it in the future. There are a good number of
people who find the notion of dynamic security policy
disturbing.

> Thanks to your effort and others we may achieve it, but I don't think
> that delaying features for a perfect implementation is the best way.
> During linuxcon 2016 Europe you said that there should be a new kind
> of LSMs, that's why I think we should make it easy for that to happen.

I agree that it's better to use a work-around today then to
let the shortcomings of the existing infrastructure stop you
from getting your job done.

>
>> think it's a bad idea to go ahead with one implementation
>> for task blobs without taking care of the others.
> Ok. Sorry if I missed this, but could you please point me why this
> could be a bad idea ?

It's a whole lot easier to maintain one sort of blob
management then a different kind for each blob. It would
be lots cleaner to have a single call that tells the
infrastructure how much space you need for all your blobs
than a separate interface for each.

> As I understand it, these are internal details that could be replaced.
> My first implementation used resizable concurrent hashtables that are
> heavily used in the networking code and it worked, and I easily
> converted the module to use Tetsuo's approach since I didn't see any
> objection for it, and it continued to work. Maybe the point should be
> *which* LSM should use the task->security and how ? The
> ModAutoRestrict module is a simple LSM which could easily work with
> any provided solution.

So I see.

> That being said, I could convert the module back and stick with
> rhashtables for now since it does not conflict with any module and it
> works well. I would like to avoid same history where Apparmor, Smack
> and TOMOYO all suffered to get mainlined, even Yama due to some
> requests...  Then I can convert the module back to use the same LSM
> infrastructure if you maintainers think that how it should go, that's
> totally fine by me. Yama internally could use the same task blob but
> it is avoiding conflicts by using lists to manage its internal data,
> that's the same design with ModAutoRestrict and rhashtables.

I think that would be the prudent approach. There is still
the possibility that blob sharing (or full stacking, if you
prefer) won't be accepted any time soon.

> Thank you for the comment!
>
