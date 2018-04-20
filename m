From: Paul Moore <paul@paul-moore.com>
Subject: Re: [RFC PATCH ghak32 V2 05/13] audit: add containerid support for
 ptrace and signals
Date: Fri, 20 Apr 2018 12:13:37 -0400
Message-ID: <CAHC9VhREkg3uEkhMdKTM0S9-jXTR4LF_T5R2rgdNyfCo_4Meow@mail.gmail.com>
References: <cover.1521179281.git.rgb@redhat.com> <8c7ff567377f4a83edac48e962c1b5b824b523c8.1521179281.git.rgb@redhat.com>
 <CAHC9VhTy4fX1hYfD5tppbP-fRaVRMXOfeJ=Et96J_rc7Jw12Bw@mail.gmail.com> <20180420010320.panie6mtdafxl65y@madcap2.tricolour.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180420010320.panie6mtdafxl65y@madcap2.tricolour.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Richard Guy Briggs <rgb@redhat.com>
Cc: cgroups@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Linux-Audit Mailing List <linux-audit@redhat.com>, linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org, ebiederm@xmission.com, luto@kernel.org, jlayton@redhat.com, carlos@redhat.com, dhowells@redhat.com, viro@zeniv.linux.org.uk, simo@redhat.com, Eric Paris <eparis@parisplace.org>, serge@hallyn.com
List-Id: linux-api@vger.kernel.org

On Thu, Apr 19, 2018 at 9:03 PM, Richard Guy Briggs <rgb@redhat.com> wrote:
> On 2018-04-18 20:32, Paul Moore wrote:
>> On Fri, Mar 16, 2018 at 5:00 AM, Richard Guy Briggs <rgb@redhat.com> wrote:

...

>> >  /*
>> >   * audit_log_container_info - report container info
>> > - * @tsk: task to be recorded
>> >   * @context: task or local context for record
>> > + * @op: containerid string description
>> > + * @containerid: container ID to report
>> >   */
>> > -int audit_log_container_info(struct task_struct *tsk, struct audit_context *context)
>> > +int audit_log_container_info(struct audit_context *context,
>> > +                             char *op, u64 containerid)
>> >  {
>> >         struct audit_buffer *ab;
>> >
>> > -       if (!audit_containerid_set(tsk))
>> > +       if (!cid_valid(containerid))
>> >                 return 0;
>> >         /* Generate AUDIT_CONTAINER_INFO with container ID */
>> >         ab = audit_log_start(context, GFP_KERNEL, AUDIT_CONTAINER_INFO);
>> >         if (!ab)
>> >                 return -ENOMEM;
>> > -       audit_log_format(ab, "contid=%llu", audit_get_containerid(tsk));
>> > +       audit_log_format(ab, "op=%s contid=%llu", op, containerid);
>> >         audit_log_end(ab);
>> >         return 0;
>> >  }
>>
>> Let's get these changes into the first patch where
>> audit_log_container_info() is defined.  Why?  This inserts a new field
>> into the record which is a no-no.  Yes, it is one single patchset, but
>> they are still separate patches and who knows which patches a given
>> distribution and/or tree may decide to backport.
>
> Fair enough.  That first thought went through my mind...  Would it be
> sufficient to move that field addition to the first patch and leave the
> rest here to support trace and signals?

I should have been more clear ... yes, that's what I was thinking; the
record format is the important part as it's user visible.

-- 
paul moore
www.paul-moore.com
