From: Djalal Harouni <tixxdz@gmail.com>
Subject: Re: [PATCH RFC v2 1/3] LSM: Allow per LSM module per "struct
 task_struct" blob.
Date: Mon, 10 Apr 2017 20:30:50 +0200
Message-ID: <CAEiveUeHedQAsjbS5Jj9imq28af0OuKAjMTudMJm7GqObRNMfQ@mail.gmail.com>
References: <1491734530-25002-1-git-send-email-tixxdz@gmail.com>
 <1491734530-25002-2-git-send-email-tixxdz@gmail.com> <f25edeb6-35e1-2f8c-8fd6-fd051c4e79ce@schaufler-ca.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <f25edeb6-35e1-2f8c-8fd6-fd051c4e79ce@schaufler-ca.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>, Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, kernel-hardening@lists.openwall.com, LSM List <linux-security-module@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Dongsu Park <dpark@posteo.net>, James Morris <james.l.morris@oracle.com>, "Serge E. Hallyn" <serge@hallyn.com>, Paul Moore <paul@paul-moore.com>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
List-Id: linux-api@vger.kernel.org

On Mon, Apr 10, 2017 at 5:50 PM, Casey Schaufler <casey@schaufler-ca.com> wrote:
> On 4/9/2017 3:42 AM, Djalal Harouni wrote:
>> From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
>>
>> Since several modules are planning to use per "struct task_struct" blob,
>> we need a layer for isolating it. Therefore, this patch introduces per LSM
>> module per "struct task_struct" blob.
>>
>> It would be possible to remember location in security_hook_heads.task_alloc
>> list and undo up to the corresponding security_hook_heads.task_free list
>> when task_alloc hook failed. But this patch calls all task_free hooks
>> without checking whether the corresponding task_alloc hook was called
>> since most modules should be able to handle this correctly.
>>
>> How to calculate amount of needed bytes and allocate memory for initial
>> task is a chicken-or-egg syndrome. We need to know how many bytes needs
>> to be allocated for initial task's security blobs before security_init()
>> is called. But security_reserve_task_blob_index() which calculates amount
>> of needed bytes is called from security_init(). We will need to split
>> module registration into three steps. The first step is call
>> security_reserve_task_blob_index() on all modules which should be
>> activated. The second step is allocate memory for the initial task's
>> security blob. The third step is actually activate all modules which
>> should be activated.
>>
>> Signed-off-by: Djalal Harouni <tixxdz@gmail.com>
>> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
>
> While I appreciate your enthusiasm, I would really like
> to see a mechanism for managing all of the blobs as being
> potentially shared rather than just the task blob. With
> infrastructure blob management being the general case we
> could stack any set of existing modules that does not
> include both SELinux and Smack. (AppArmor is threatening
> to join that set, but we're still waiting on that) I

Yes! most of the other kernel maintainers I discussed the feature with
did not even believe or knew that LSM stacking is possible! Some other
kernel frameworks are being replaced with new ones (I'm not sure if
the old ones were perfect!)... but what I'm trying to say is that we
should make it easy for dynamic LSM plugins model so they can explore
the interface, and maybe after some time the whole framework will even
be replaced with a better one...
Thanks to your effort and others we may achieve it, but I don't think
that delaying features for a perfect implementation is the best way.
During linuxcon 2016 Europe you said that there should be a new kind
of LSMs, that's why I think we should make it easy for that to happen.

> think it's a bad idea to go ahead with one implementation
> for task blobs without taking care of the others.

Ok. Sorry if I missed this, but could you please point me why this
could be a bad idea ?

As I understand it, these are internal details that could be replaced.
My first implementation used resizable concurrent hashtables that are
heavily used in the networking code and it worked, and I easily
converted the module to use Tetsuo's approach since I didn't see any
objection for it, and it continued to work. Maybe the point should be
*which* LSM should use the task->security and how ? The
ModAutoRestrict module is a simple LSM which could easily work with
any provided solution.

That being said, I could convert the module back and stick with
rhashtables for now since it does not conflict with any module and it
works well. I would like to avoid same history where Apparmor, Smack
and TOMOYO all suffered to get mainlined, even Yama due to some
requests...  Then I can convert the module back to use the same LSM
infrastructure if you maintainers think that how it should go, that's
totally fine by me. Yama internally could use the same task blob but
it is avoiding conflicts by using lists to manage its internal data,
that's the same design with ModAutoRestrict and rhashtables.

Thank you for the comment!

-- 
tixxdz
