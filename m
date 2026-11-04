Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=166.70.13.232
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793763481;
	b=HvXZC13kI2U825KCyQtUYz/1xKGXUp+B84+OKwXR8tJkBujADIGYj8BDviIY3Uz4sxKX
	 B+4c0vrqLQkFv5vz2ET7iGjnbT8cADRaP9u2Wiw3UIy5o4OQ46xkcGbcXEPJCyajffzst
	 m1+wgMyrL9WmU8InxNRN/pm4LDN1Str4FbkxWm2fcpYdCmqnEErihIcOAxzVPodlR7yni
	 aiYsRSpRN/Dn2l/Q+DPYxcCExxmgG69XlsjGvWH/jt+yE4ezupGB5KP2ZwG+kRjKPg+C6
	 3glmZxxmq0KJj6l/MXZJBKU3QRChB3Iaa71BeK2YYTFkVQ407AZXEPqzoI6dyW3Pvvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793763481;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:In-Reply-To:
	 References:Date:Message-ID:User-Agent:MIME-Version:Content-Type:
	 X-XM-SPF:X-XM-AID:X-Spam-Checker-Version:X-Spam-Level:X-Spam-Status:
	 X-Spam-Report:X-Spam-DCC:X-Spam-Combo:X-Spam-Relay-Country:
	 X-Spam-Timing:Subject:X-SA-Exim-Connect-IP:X-SA-Exim-Rcpt-To:
	 X-SA-Exim-Mail-From:X-SA-Exim-Scanned;
	bh=kDqwx+3PxNKfZCj2JhmKBNa78z0Kr9aqLUdVPYRM3Xo=;
	b=ge5Za5aJorkIKc5fsR6Pu/j0vN5IkQYOVpHisnX55LYGUGmovFPyXmjugswdsSNB52Zy
	 vyuJxdmCB6qLH2yK0V/uU6CoM8LxOxHx0PtfF5DU6h4ieCYOPUYrFpG9YwiJYto1iAN6h
	 qRQR9G8ShYSoCNyK+C2ZoOzefK0p1znBYkGKQtGUmwBsMJBd8ksnspmj26DOjdcJRHIm6
	 G4JEOpfeY7JwWkjCfz+F1Z/r2k078HXY2kvfd6z2SwfgRRJPbZY9Qxpass8dp0RS/DMUj
	 Zm3AIYFB7CDLGx3NOizRhq1BBac3+NHrjJ5LvQK23Nz5UsUEU1UzCRjBP02b30lNuhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=xmission.com;
	spf=pass smtp.mailfrom=xmission.com;
	dkim=pass header.d=xmission.com header.i=@xmission.com header.a=rsa-sha256 header.s=xmission header.b=r+Gnh+jK;
	arc=none smtp.remote-ip=166.70.13.232
Received: from out02.mta.xmission.com (out02.mta.xmission.com [166.70.13.232])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78B42606A31B;
	Wed,  4 Nov 2026 03:38:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 78B42606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=xmission.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xmission.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=xmission.com header.i=@xmission.com header.a=rsa-sha256 header.s=xmission header.b=r+Gnh+jK
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=simple/simple; d=xmission.com;
	 s=xmission; h=Subject:Content-Type:MIME-Version:Message-ID:Date:References:
	In-Reply-To:Cc:To:From:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=TqBt9UO+EMMHepGoKLFhPlrkCxqNTuX9E4MRFVfu4ng=; b=r+Gnh+jKlvBK+V+RKchdmVz3cO
	eDU91omtyoB91RXbG+A5BiwPAAQvEqQTJyKZaHwoYozHY8Z//QgUp2Dk4UG0kYzmDszRzzwiX1yLa
	r5VXFUY1lwEIYVWJYsyETROQZHGbkeyoKZGCjYan2u7ynEgEiHVjKS2SUT/0avHCBdw8=;
Received: from in02.mta.xmission.com ([166.70.13.52]:34732)
	by out02.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.93)
	(envelope-from <ebiederm@xmission.com>)
	id 1xORov-009N8y-MK; Tue, 03 Nov 2026 20:37:53 -0700
Received: from ip72-198-196-98.om.om.cox.net ([72.198.196.98]:33406 helo=email.froward.int.ebiederm.org.xmission.com)
	by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.93)
	(envelope-from <ebiederm@xmission.com>)
	id 1xORou-007cdp-LX; Tue, 03 Nov 2026 20:37:53 -0700
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>,  Linux API
 <linux-api@vger.kernel.org>
In-Reply-To: <CALCETrWDJKr=LMzfPjwwRRuKapFKQ_OaYF6qYz-9Cs91xAXUgA@mail.gmail.com>
	(Andy Lutomirski's message of "Tue, 3 Nov 2026 11:58:38 -0800")
References: <CALCETrWDJKr=LMzfPjwwRRuKapFKQ_OaYF6qYz-9Cs91xAXUgA@mail.gmail.com>
Date: Tue, 03 Nov 2026 21:37:48 -0600
Message-ID: <87se1hclmb.fsf@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1xORou-007cdp-LX;;;mid=<87se1hclmb.fsf@email.froward.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=72.198.196.98;;;frm=ebiederm@xmission.com;;;sPfnum=0;;;sPf=pass
X-XM-AID: U2FsdGVkX1/ejodJehYrLy+6ajNDKQv/5agvXonhAYs=
X-Spam-Level: 
X-Spam-Report: 
	* -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.2 XM_B_SpammyWords One or more commonly used spammy words
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andy Lutomirski <luto@amacapital.net>
X-Spam-Relay-Country: 
X-Spam-Timing: total 543 ms - load_scoreonly_sql: 0.05 (0.0%),
	signal_user_changed: 10 (1.9%), b_tie_ro: 9 (1.7%), parse: 1.00 (0.2%),
	 extract_message_metadata: 17 (3.1%), get_uri_detail_list: 3.0 (0.5%),
	tests_pri_-2000: 15 (2.7%), tests_pri_-1000: 2.00 (0.4%),
	tests_pri_-950: 0.94 (0.2%), tests_pri_-900: 0.68 (0.1%),
	tests_pri_-90: 71 (13.1%), check_bayes: 70 (12.9%), b_tokenize: 10
	(1.9%), b_tok_get_all: 12 (2.2%), b_comp_prob: 3.6 (0.7%),
	b_tok_touch_all: 39 (7.3%), b_finish: 1.10 (0.2%), tests_pri_0: 413
	(76.0%), check_dkim_signature: 0.46 (0.1%), check_dkim_adsp: 1.99
	(0.4%), poll_dns_idle: 0.93 (0.2%), tests_pri_10: 1.29 (0.2%),
	tests_pri_500: 8 (1.4%), rewrite_mail: 0.00 (0.0%)
Subject: Re: Accidental mountns/tmpfs API break from 2016?
X-SA-Exim-Connect-IP: 166.70.13.52
X-SA-Exim-Rcpt-To: linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, luto@amacapital.net
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on out02.mta.xmission.com); SAEximRunCond expanded to false

Andy Lutomirski <luto@amacapital.net> writes:

> Hi-
>
> I (well, an LLM following my rather explicit instructions) just wrote
> a little tool to make a tmpfs as an unprivileged user: it unshares
> userns and mountns, makes a tmpfs, fchdirs to it, and prints
> /proc/PID/cwd to stdout.  Full source below.
>
> I was a bit surprised that trying to create anything in the tmpfs did
> not work without a uid_map and gid_map.  It looks like it came from:
>
> commit 036d523641c66bef713042894a17f4335f199e49
> Author: Eric W. Biederman <ebiederm@xmission.com>
> Date:   Fri Jul 1 12:52:06 2016 -0500
>
>     vfs: Don't create inodes with a uid or gid unknown to the vfs
>
>     It is expected that filesystems can not represent uids and gids from
>     outside of their user namespace.  Keep things simple by not even
>     trying to create filesystem nodes with non-sense uids and gids.
>
>     Acked-by: Seth Forshee <seth.forshee@canonical.com>
>     Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
>
>
> Now my tool won't actually run on a pre-2016 kernel due to use of
> fsopen, and I'm not about to say that a decade-old commit broke my ABI
> and needs to be reverted.  But I am rather curious whether this rule
> actually makes sense.

I am pretty certain it was deliberate at the time. 

> I'm not creating an idmapped mount, and I'm
> using tmpfs, which could not care less about the mapping as far as I
> know.
>
> Would it make sense to only enforce this for filesystems that care?

Interesting question.  You are in a user namespace.  You are
running as a user that does not exist in your user namespace.
You want to create files.

You can map a that single uid and gid without privileges.
So there is no hardship in getting a uid and gid in your user namespace.

Is it just the extra bit of code to perform that write that is the
problem?

Why would you want to be able to create files as a owned by a user
from another user namespace?  Even if you created them reading them
would show an 0xfffe the invalid uid/gid.  I think there are then
some difficulties in using those files as well.

Why would you want to do much of anything as without having a
properly setup uid or gid?

At a quick look tmpfs just uses vfs inodes which use kuid_t and kgid_t
so it theoretically would be ok.

Still what would be the motivation for supporting something so silly?

If there is a good use case I could see it making sense to support it.

Short of a good use case we are talking about having to support weird
corner cases that no one really cares about that will just bit-rot.

Note.  You can identity map your original uid and gid, instead of
mapping your uid and gid 0.


We have occasionally talked about having a uid space that doesn't map to
the outside world.  Perhaps by having a 64bit kuid, while uid's remain
32bit.  I don't think anyone has pushed forward and merged that yet.  I
did see a proposal form "cells" the other day that appeared to have a
version of that idea implemented.  I mention it just in case that is
what you were expecting to exist in a fresh user namespace.

Eric

> --Andy
>
>
> #include <cerrno>
> #include <cstdio>
> #include <fcntl.h>
> #include <linux/mount.h>
> #include <sched.h>
> #include <string>
> #include <string_view>
> #include <sys/syscall.h>
> #include <system_error>
> #include <unistd.h>
>
> namespace {
> void Check(long result, const char *operation) {
>     if (result < 0)
>         throw std::system_error(errno, std::generic_category(), operation);
> }
>
> struct OwnedFd {
>     int fd;
>
>     ~OwnedFd() { close(fd); }
> };
>
> void WriteAll(int fd, std::string_view bytes) {
>     while (!bytes.empty()) {
>         auto n = write(fd, bytes.data(), bytes.size());
>         if (n < 0 && errno == EINTR)
>             continue;
>         Check(n, "write");
>         if (n == 0)
>             throw std::system_error(EIO, std::generic_category(),
> "zero-length write");
>         bytes.remove_prefix(n);
>     }
> }
>
> void WriteFile(const char *path, std::string_view bytes) {
>     OwnedFd file{open(path, O_WRONLY | O_CLOEXEC)};
>     Check(file.fd, path);
>     WriteAll(file.fd, bytes);
> }
> }
>
> int cmd_temp_shm(int argc, char **) {
>     if (argc != 1) {
>         fprintf(stderr, "Usage: lktool temp_shm\n");
>         return 1;
>     }
>
>     try {
>         auto uid = getuid();
>         auto gid = getgid();
>         Check(unshare(CLONE_NEWUSER | CLONE_NEWNS), "unshare user and
> mount namespaces");
>
>         /*
>          * The outside UID and GID need to be mapped in order for the
> outside tasks
>          * to create dentries.  This comes from commit 036d523641c6
> ("vfs: Don't create
>          * inodes with a uid or gid unknown to the vfs"), which I
> think may have been
>          * a mistake.
>          */
>         WriteFile("/proc/self/setgroups", "deny\n");
>         WriteFile("/proc/self/uid_map", "0 " + std::to_string(uid) + " 1\n");
>         WriteFile("/proc/self/gid_map", "0 " + std::to_string(gid) + " 1\n");
>
>         OwnedFd context{static_cast<int>(syscall(SYS_fsopen, "tmpfs",
> FSOPEN_CLOEXEC))};
>         Check(context.fd, "fsopen tmpfs");
>         Check(syscall(SYS_fsconfig, context.fd, FSCONFIG_CMD_CREATE,
> nullptr, nullptr, 0),
>               "fsconfig create tmpfs");
>
>         OwnedFd mount{static_cast<int>(syscall(SYS_fsmount,
> context.fd, FSMOUNT_CLOEXEC, 0))};
>         Check(mount.fd, "fsmount tmpfs");
>         Check(fchdir(mount.fd), "fchdir tmpfs");
>
>         // The detached mount is kept alive by cwd and the mount descriptor.
>         // No mount is attached to the inherited filesystem hierarchy.
>         std::string path = "/proc/" + std::to_string(getpid()) + "/cwd";
>         path.push_back('\0');
>         WriteAll(STDOUT_FILENO, path);
>         for (;;)
>             pause();
>     } catch (const std::system_error &e) {
>         fprintf(stderr, "lktool temp_shm: %s\n", e.what());
>         return 1;
>     }
> }
