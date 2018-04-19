From: Paul Moore <paul@paul-moore.com>
Subject: Re: [RFC PATCH ghak32 V2 09/13] audit: add containerid support for
 config/feature/user records
Date: Thu, 19 Apr 2018 08:59:29 -0400
Message-ID: <CAHC9VhRL2PT65_c1OR=SNnicR+XVx33ZuuCttJ-OG+g3aBzsxg@mail.gmail.com>
References: <cover.1521179281.git.rgb@redhat.com> <c34a7a95eb045a62e2443457979db9d7afbd9aee.1521179281.git.rgb@redhat.com>
 <CAHC9VhQ-i5oA48sXXnN2fP06t5=9-NMoY0bKcGXorQw2k=CK0Q@mail.gmail.com> <20180419123109.ab7gsnwrbtog4tbf@madcap2.tricolour.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180419123109.ab7gsnwrbtog4tbf@madcap2.tricolour.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Richard Guy Briggs <rgb@redhat.com>
Cc: cgroups@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Linux-Audit Mailing List <linux-audit@redhat.com>, linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org, ebiederm@xmission.com, luto@kernel.org, jlayton@redhat.com, carlos@redhat.com, dhowells@redhat.com, viro@zeniv.linux.org.uk, simo@redhat.com, Eric Paris <eparis@parisplace.org>, serge@hallyn.com
List-Id: linux-api@vger.kernel.org

On Thu, Apr 19, 2018 at 8:31 AM, Richard Guy Briggs <rgb@redhat.com> wrote:
> On 2018-04-18 21:27, Paul Moore wrote:
>> On Fri, Mar 16, 2018 at 5:00 AM, Richard Guy Briggs <rgb@redhat.com> wrote:
>> > Add container ID auxiliary records to configuration change, feature set change
>> > and user generated standalone records.
>> >
>> > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
>> > ---
>> >  kernel/audit.c       | 50 ++++++++++++++++++++++++++++++++++++++++----------
>> >  kernel/auditfilter.c |  5 ++++-
>> >  2 files changed, 44 insertions(+), 11 deletions(-)
>> >
>> > diff --git a/kernel/audit.c b/kernel/audit.c
>> > index b238be5..08662b4 100644
>> > --- a/kernel/audit.c
>> > +++ b/kernel/audit.c
>> > @@ -400,8 +400,9 @@ static int audit_log_config_change(char *function_name, u32 new, u32 old,
>> >  {
>> >         struct audit_buffer *ab;
>> >         int rc = 0;
>> > +       struct audit_context *context = audit_alloc_local();
>>
>> We should be able to use current->audit_context here right?  If we
>> can't for every caller, perhaps we pass an audit_context as an
>> argument and only allocate a local context when the passed
>> audit_context is NULL.
>>
>> Also, if you're not comfortable always using current, just pass the
>> audit_context as you do with audit_log_common_recv_msg().
>
> As mentioned in the tree/watch/mark patch, this is all obsoleted by
> making the AUDIT_CONFIG_CHANGE record a SYSCALL auxiliary record.

You've known about my desire to connect records for quite some time.

> This review would have been more helpful a month and a half ago.

If you really want to sink to that level of discussion, better quality
patches from you would have been helpful too, that is the one of the
main reasons why it takes so long to review your code.  Let's keep the
commentary focused on the code, discussions like this aren't likely to
be helpful to anyone.

-- 
paul moore
www.paul-moore.com
