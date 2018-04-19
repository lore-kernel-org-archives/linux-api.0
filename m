From: Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [RFC PATCH ghak32 V2 01/13] audit: add container id
Date: Wed, 18 Apr 2018 18:15:46 -0700
Message-ID: <1adffa90-020d-54e1-fbf5-7fc929ccb44c@schaufler-ca.com>
References: <cover.1521179281.git.rgb@redhat.com>
 <e284617ad667ad8f17958dd8babb87fe1b4d7205.1521179281.git.rgb@redhat.com>
 <CAHC9VhTyvxxj2e2Gn+iyW6iLLeYB7hp8a+JvfeMmJ2nUPqtEaw@mail.gmail.com>
 <32d3e7a6-36f0-571a-bb91-67f746c7eafa@schaufler-ca.com>
 <CAHC9VhTz-pr-iUVv-+R3ShwEKSHDsweDGuN7255HV7Cu3ZYPEw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHC9VhTz-pr-iUVv-+R3ShwEKSHDsweDGuN7255HV7Cu3ZYPEw@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Paul Moore <paul@paul-moore.com>
Cc: Richard Guy Briggs <rgb@redhat.com>, cgroups@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Linux-Audit Mailing List <linux-audit@redhat.com>, linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org, ebiederm@xmission.com, luto@kernel.org, jlayton@redhat.com, carlos@redhat.com, dhowells@redhat.com, viro@zeniv.linux.org.uk, simo@redhat.com, Eric Paris <eparis@parisplace.org>, serge@hallyn.com
List-Id: linux-api@vger.kernel.org

On 4/18/2018 5:46 PM, Paul Moore wrote:
> On Wed, Apr 18, 2018 at 8:41 PM, Casey Schaufler <casey@schaufler-ca.com> wrote:
>> On 4/18/2018 4:47 PM, Paul Moore wrote:
>>> On Fri, Mar 16, 2018 at 5:00 AM, Richard Guy Briggs <rgb@redhat.com> wrote:
>>>> Implement the proc fs write to set the audit container ID of a process,
>>>> emitting an AUDIT_CONTAINER record to document the event.
>>>> ...
>>>>
>>>> diff --git a/include/linux/sched.h b/include/linux/sched.h
>>>> index d258826..1b82191 100644
>>>> --- a/include/linux/sched.h
>>>> +++ b/include/linux/sched.h
>>>> @@ -796,6 +796,7 @@ struct task_struct {
>>>>  #ifdef CONFIG_AUDITSYSCALL
>>>>         kuid_t                          loginuid;
>>>>         unsigned int                    sessionid;
>>>> +       u64                             containerid;
>>> This one line addition to the task_struct scares me the most of
>>> anything in this patchset.  Why?  It's a field named "containerid" in
>>> a perhaps one of the most widely used core kernel structures; the
>>> possibilities for abuse are endless, and it's foolish to think we
>>> would ever be able to adequately police this.
>> If we can get the LSM infrastructure managed task blobs from
>> module stacking in ahead of this we could create a trivial security
>> module to manage this. It's not as if there aren't all sorts of
>> interactions between security modules and the audit system already.
> While yes, there are plenty of interactions between the two, it is
> possible to use audit without the LSMs and I would like to preserve
> that.  

Fair enough.

> Further, I don't want to entangle two very complicated code
> changes or make the audit container ID effort dependent on LSM
> stacking.

Also fair, although the use case for container audit IDs is
already pulling in audit, namespaces (yeah, I know it's not
necessary for a container to use namespaces) security modules
(stacked and/or namespaced), cgroups and who knows what else.

> You're a good salesman Casey, but you're not that good ;)

I have to keep the skills sharpened somehow!

OK, I'll grant that this isn't a great fit.
