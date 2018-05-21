From: Paul Moore <paul@paul-moore.com>
Subject: Re: [RFC PATCH ghak32 V2 13/13] debug audit: read container ID of a process
Date: Mon, 21 May 2018 16:06:31 -0400
Message-ID: <CAHC9VhQruN88t-R9Qo3e4hwCZ58RAyrmEmH1nY4RR6NZaiBzGQ@mail.gmail.com>
References: <cover.1521179281.git.rgb@redhat.com> <1081821010c124fe4e35984ec3dac1654453bb7c.1521179281.git.rgb@redhat.com>
 <3001737.MkQ41rgtZF@x2> <87muwshl4z.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87muwshl4z.fsf@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>, Steve Grubb <sgrubb@redhat.com>, Richard Guy Briggs <rgb@redhat.com>
Cc: simo@redhat.com, jlayton@redhat.com, linux-api@vger.kernel.org, containers@lists.linux-foundation.org, LKML <linux-kernel@vger.kernel.org>, Eric Paris <eparis@parisplace.org>, dhowells@redhat.com, carlos@redhat.com, linux-audit@redhat.com, viro@zeniv.linux.org.uk, luto@kernel.org, netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org, serge@hallyn.com
List-Id: linux-api@vger.kernel.org

On Mon, May 21, 2018 at 3:19 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> Steve Grubb <sgrubb@redhat.com> writes:
>
>> On Friday, March 16, 2018 5:00:40 AM EDT Richard Guy Briggs wrote:
>>> Add support for reading the container ID from the proc filesystem.
>>
>> I think this could be useful in general. Please consider this to be part of
>> the full patch set and not something merely used to debug the patches.
>
> Only with an audit specific name.
>
> As it is:
>
> Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>
>
> The truth is the containerid name really stinks and is quite confusing
> and does not imply that the label applies only to audit.  And little
> things like this make me extremely uncofortable with it.

It also makes the audit container ID (notice how I *always* call it
the *audit* container ID? that is not an accident) available for
userspace applications to abuse.  Perhaps in the future we can look at
ways to make this more available to applications, but this patch is
not the answer.

-- 
paul moore
www.paul-moore.com
