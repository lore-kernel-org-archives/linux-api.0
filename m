From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH v2 review 09/11] quota: Handle quota data stored in s_user_ns.
Date: Wed, 06 Jul 2016 12:51:17 -0500
Message-ID: <87poqqbqp6.fsf@x220.int.ebiederm.org>
References: <87ziq03qnj.fsf@x220.int.ebiederm.org>
	<20160702172035.19568-1-ebiederm@xmission.com>
	<20160702172035.19568-9-ebiederm@xmission.com>
	<87mvm03pxy.fsf_-_@x220.int.ebiederm.org>
	<20160704091100.GD5200@quack2.suse.cz>
	<87d1msumhy.fsf@x220.int.ebiederm.org>
	<20160705205721.GG27480@dastard>
	<8737nnrcyy.fsf@x220.int.ebiederm.org>
	<20160706063504.GH27480@dastard>
	<20160706082545.GC14067@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20160706082545.GC14067@quack2.suse.cz> (Jan Kara's message of
	"Wed, 6 Jul 2016 10:25:45 +0200")
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: Dave Chinner <david@fromorbit.com>, Seth Forshee <seth.forshee@canonical.com>, Jann Horn <jannh@google.com>, Linux API <linux-api@vger.kernel.org>, Linux Containers <containers@lists.linux-foundation.org>, Andy Lutomirski <luto@amacapital.net>, James Bottomley <James.Bottomley@HansenPartnership.com>, Michael Kerrisk <mtk.manpages@gmail.com>, linux-fsdevel@vger.kernel.org, Djalal Harouni <tixxdz@gmail.com>
List-Id: linux-api@vger.kernel.org

Jan Kara <jack@suse.cz> writes:

> On Wed 06-07-16 16:35:04, Dave Chinner wrote:

>> All the more reason you should be adding the same guard to all the
>> other filesystems....
>>
>> All i'm asking you to do is to make this check in a way that all
>> filesystems that implement quotas will execute it. Don't leave
>> landmines with security implications around - make sure all
>> filesystems have the same protections.

That is exactly what I am doing.  Ensuring people don't think the
generic quota file code has been closely audited and reviewed and deemed
safe against malicious users.

> Well, I'm not sure I follow you here. VFS quotas are a generic code used by
> a few filesystems. So I can imagine that someone would decide to enable
> FS_USERNS_MOUNT for one of those filesystems without thinking about quotas
> and then Eric's check would trigger and possibly save use from some
> problems.
>
> When someone decides to enable FS_USERNS_MOUNT for XFS, he will have
> presumably made sure all parts of XFS are safe, including its quota
> implementation.
>
> I don't want to stop you or Eric in adding an extra check in XFS, I just
> have hard time to see how that check would trigger and how XFS quota is
> different from other XFS parts...

Exactly.

While it is true that the quota file code has not been deemed safe for
attack by malicious users on any filesystem.  It only matters if the
entire filesystem has been deemed safe by setting FS_USERNS_MOUNT.  So
the only possible avenue of confusion I can see is with the default
quota file code in dquot.c and company which I am addressing.

The fully generic parts of quota in quota.c that every one uses will
handle all of the weird s_user_ns != &init_user_ns cases at the end
of this patchset so there is nothing to worry about there either.

So I don't see additional checks worth adding anywhere.  Dave if you want
to send me an XFS patch or point out where such a check would belong in
XFS I won't be opposed to carrying it in my tree along with the rest of
this change.   I probably will be puzzled about what makes that code
need an extra check but I won't be opposed to carring such a patch.

Eric
