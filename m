From: Paul Moore <paul@paul-moore.com>
Subject: Re: [RFC PATCH V1 01/12] audit: add container id
Date: Fri, 2 Mar 2018 10:48:42 -0500
Message-ID: <CAHC9VhQi2QC8_e1fgYr=bfTACdtpgXZubc6S18r+1+9qf6TJ8w@mail.gmail.com>
References: <cover.1519930146.git.rgb@redhat.com> <2e5d93ee46feca915a101c2fc3062da674a98223.1519930146.git.rgb@redhat.com>
 <20180302014101.jtfd2eeyxmvxcjpf@madcap2.tricolour.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180302014101.jtfd2eeyxmvxcjpf@madcap2.tricolour.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Richard Guy Briggs <rgb@redhat.com>
Cc: cgroups@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Linux-Audit Mailing List <linux-audit@redhat.com>, linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org, mszeredi@redhat.com, ebiederm@xmission.com, simo@redhat.com, jlayton@redhat.com, carlos@redhat.com, dhowells@redhat.com, viro@zeniv.linux.org.uk, luto@kernel.org, Eric Paris <eparis@parisplace.org>, trondmy@primarydata.com, serge@hallyn.com
List-Id: linux-api@vger.kernel.org

On Thu, Mar 1, 2018 at 8:41 PM, Richard Guy Briggs <rgb@redhat.com> wrote:
> On 2018-03-01 14:41, Richard Guy Briggs wrote:
>> Implement the proc fs write to set the audit container ID of a process,
>> emitting an AUDIT_CONTAINER record to document the event.
>>
>> This is a write from the container orchestrator task to a proc entry of
>> the form /proc/PID/containerid where PID is the process ID of the newly
>> created task that is to become the first task in a container, or an
>> additional task added to a container.
>>
>> The write expects up to a u64 value (unset: 18446744073709551615).
>>
>> This will produce a record such as this:
>> type=UNKNOWN[1333] msg=audit(1519903238.968:261): op=set pid=596 uid=0 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 auid=0 tty=pts0 ses=1 opid=596 old-contid=18446744073709551615 contid=123455 res=0
>>
>> The "op" field indicates an initial set.  The "pid" to "ses" fields are
>> the orchestrator while the "opid" field is the object's PID, the process
>> being "contained".  Old and new container ID values are given in the
>> "contid" fields, while res indicates its success.
>>
>> It is not permitted to self-set, unset or re-set the container ID.  A
>> child inherits its parent's container ID, but then can be set only once
>> after.
>
> There are more restrictions coming later:
> - check that the child being set has no children or threads yet, or
>   forcibly set them all to the same container ID (assuming they all pass
>   the same tests).  This will also prevent an orch from setting its
>   parent and other tit-for-tat games to circumvent the basic checks.

FYI, I think you may have a problem with something in your outgoing
mail path; I didn't receive the original patchset you are referencing
and it doesn't appear in the mail archive either.

-- 
paul moore
www.paul-moore.com
