Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=166.70.13.233
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794225947;
	b=buTeHxfLlm7QVlSAfA4ES76lLEX68jmUpKuEXj33zWsuE2RLdNkyhAgN1CR1E7Jjeiov
	 84+puLtdgw882Lbh0we0S8l76tcDs+BbKtwfU+2w1j+gPQqh/ooQUJCPSz4SFw260MCRu
	 z7fBiFXEFXWaUOG+DMD4n8FgPD9FeQzkeuoU5etLX248GEnxoH/vwdv16q8ndyBsH/SSs
	 ylg0DkCZWJvaZNe3Tu0OuNf6fL9qZD6lkyvATRK0d6DsfD0xD9IlYMfVRsbl3HgVds32T
	 rcgF3xLUpxKzwBafUSLG9Xuz7wZTxm6APn5g1zrwBkZayKXA5KhGhjVyGxszdRIXMtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794225947;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:In-Reply-To:
	 References:Date:Message-ID:User-Agent:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-XM-SPF:X-XM-AID:X-Spam-Checker-Version:
	 X-Spam-Level:X-Spam-Status:X-Spam-Virus:X-Spam-Report:X-Spam-DCC:
	 X-Spam-Combo:X-Spam-Relay-Country:X-Spam-Timing:Subject:
	 X-SA-Exim-Connect-IP:X-SA-Exim-Rcpt-To:X-SA-Exim-Mail-From:
	 X-SA-Exim-Scanned;
	bh=0WBPpAS8QhIFFinpCvXWvHgYUMT4lMip8rLHtHsH/84=;
	b=uGDy1fSr+Adqfy3T/iF8PsJd9lyUr0LxiZgX3myWd3XE+qC2nLbgvj6iDSZY3deJs92u
	 qKgaoDVhUfioI3mhHV2eTFgz24bQrLP8VgeKDq2SkSwFIzoXG11W6gX2/RX5aElAvxlrt
	 RfNcaBpnVqGVRx3hihNM0qEFMd3puapNDtOdElJuynOh+6srXxpUfFkrBsQGxKjALVmOp
	 2OWjFfcoHTnX4sen5lC6uczcIZ/P2kgF4MFffItuaSpF0K4kYep4Hczc8XVWFZ1jMDNoC
	 0XAS0SmDPMKGKsBYEIVy7LCCSHUe5hWQNTGFqLkkTPLzxD1GpHXg3Vf1C1mTW1wgnpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=xmission.com;
	spf=pass smtp.mailfrom=xmission.com;
	dkim=pass header.d=xmission.com header.i=@xmission.com header.a=rsa-sha256 header.s=xmission header.b="m1+sWa/Q";
	arc=none smtp.remote-ip=166.70.13.233
Received: from out03.mta.xmission.com (out03.mta.xmission.com [166.70.13.233])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81CD9606A31C;
	Mon,  9 Nov 2026 12:05:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 81CD9606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=xmission.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xmission.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=xmission.com header.i=@xmission.com header.a=rsa-sha256 header.s=xmission header.b=m1+sWa/Q
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=simple/simple; d=xmission.com;
	 s=xmission; h=Subject:Content-Transfer-Encoding:Content-Type:MIME-Version:
	Message-ID:Date:References:In-Reply-To:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=NImTGobAjdhsHF45Qh7scPijta2lkjTwAUUTKpVGc6o=; b=m1+sWa/Qpp0nS7vN6coLeVl2tr
	2mxFaXvYgxOQbc10uwXyIdHoYMEeLc7Z/KvFT0uE4VLSoYi2BEuno/WVJJ9FfvK3ZxizTmG7h2y+f
	WolqNsOdpzD9pRdkFeVwRTe3yl+9Z3ZAZgCZY1DcQ0IeBue3caDGyBvMGwWMAIHDPYQg=;
Received: from in01.mta.xmission.com ([166.70.13.51]:41670)
	by out03.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.93)
	(envelope-from <ebiederm@xmission.com>)
	id 1xQO83-008JTB-Tn; Mon, 09 Nov 2026 05:05:39 -0700
Received: from ip72-198-196-98.om.om.cox.net ([72.198.196.98]:59876 helo=email.froward.int.ebiederm.org.xmission.com)
	by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.93)
	(envelope-from <ebiederm@xmission.com>)
	id 1xQO82-007Pwb-Kg; Mon, 09 Nov 2026 05:05:39 -0700
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>,  Linux API
 <linux-api@vger.kernel.org>
In-Reply-To: <87bj82d3ic.fsf@email.froward.int.ebiederm.org> (Eric
	W. Biederman's message of "Thu, 05 Nov 2026 21:48:11 -0600")
References: <CALCETrWDJKr=LMzfPjwwRRuKapFKQ_OaYF6qYz-9Cs91xAXUgA@mail.gmail.com>
	<87se1hclmb.fsf@email.froward.int.ebiederm.org>
	<CALCETrXnZVq4pcmo=2T2S=yzWuj9Q5tvrpuZTXzU4ptHCDnjBA@mail.gmail.com>
	<87bj82d3ic.fsf@email.froward.int.ebiederm.org>
Date: Mon, 09 Nov 2026 06:05:33 -0600
Message-ID: <874idq8b1u.fsf@email.froward.int.ebiederm.org>
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
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-XM-SPF: eid=1xQO82-007Pwb-Kg;;;mid=<874idq8b1u.fsf@email.froward.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=72.198.196.98;;;frm=ebiederm@xmission.com;;;sPfnum=0;;;sPf=pass
X-XM-AID: U2FsdGVkX1/OO6e5cT4bbCckn1cBRowbcpc8DdfAd2c=
X-Spam-Level: 
X-Spam-Virus: No
X-Spam-Report: 
	* -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4999]
	*  0.0 XM_B_Unicode BODY: Testing for specific types of unicode
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.0 XM_B_EmailChain RAW: Email Chain Detected
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.2 XM_B_SpammyWords One or more commonly used spammy words
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andy Lutomirski <luto@amacapital.net>
X-Spam-Relay-Country: 
X-Spam-Timing: total 787 ms - load_scoreonly_sql: 0.08 (0.0%),
	signal_user_changed: 4.9 (0.6%), b_tie_ro: 3.4 (0.4%), parse: 1.39
	(0.2%), extract_message_metadata: 15 (1.9%), get_uri_detail_list: 2.4
	(0.3%), tests_pri_-2000: 27 (3.4%), tests_pri_-1000: 2.0 (0.3%),
	tests_pri_-950: 1.02 (0.1%), tests_pri_-900: 0.82 (0.1%),
	tests_pri_-90: 261 (33.2%), check_bayes: 259 (32.9%), b_tokenize: 9
	(1.1%), b_tok_get_all: 10 (1.3%), b_comp_prob: 3.2 (0.4%),
	b_tok_touch_all: 232 (29.5%), b_finish: 1.13 (0.1%), tests_pri_0: 459
	(58.3%), check_dkim_signature: 0.58 (0.1%), check_dkim_adsp: 3.8
	(0.5%), poll_dns_idle: 1.76 (0.2%), tests_pri_10: 1.85 (0.2%),
	tests_pri_500: 9 (1.1%), rewrite_mail: 0.00 (0.0%)
Subject: Re: Accidental mountns/tmpfs API break from 2016?
X-SA-Exim-Connect-IP: 166.70.13.51
X-SA-Exim-Rcpt-To: linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, luto@amacapital.net
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on out03.mta.xmission.com); SAEximRunCond expanded to false

"Eric W. Biederman" <ebiederm@xmission.com> writes:

> Andy Lutomirski <luto@amacapital.net> writes:
>
>  On Tue, Nov 3, 2026 at 7:37=E2=80=AFPM Eric W. Biederman <ebiederm@xmiss=
ion.com> wrote:
>>>
>>> Andy Lutomirski <luto@amacapital.net> writes:

>> Hah, you haven't quite figured out the ridiculous thing I'm doing. :)
>> What I want is a temporary tmpfs that I can create as an unprivileged
>> user.  Linux doesn't let me do that directly, so I'm kludging it.
>> Shell transcript, edited for clarity:
>>
>> #### Make a tmpfs, keeping the tool running to keep it alive
>> $ ./temp_shm &
>> [1] 34157
>> /proc/34157/cwd
>>
>> #### cd to the tmpfs, which references it and keeps it alive
>> $ cd /proc/34157/cwd
>>
>> #### Kill the tool, since we're done with it
>> $ fg
>> bin/lktool temp_shm     (wd: /workspaces/master)
>> ^C
>>
>> #### cwd is a working tmpfs!
>> $ echo "Look a tmpfs!" >some_file
>>
>> #### and it has no '..', as expected :)
>> $ cd ..                  # and it has
>> cd: error retrieving current directory: getcwd: cannot access parent
>> directories: No such file or directory
>>
>> This whole workflow runs in the init userns and the init mountns,
>> which is exactly what I wanted.  And now I have a tmpfs that I can use
>> to run my test suite unprivileged to test some cool code that *needs*
>> a tmpfs.  (Yes, I could probably use /dev/shm, but that's messy and I
>> don't want to.)
>>
>> I'm not actually banging this out in shell, but I am running literally
>> the C++ code I posted as a subprocess called by my test harness.
>>
>> The user creating files is not in the mountns or the userns, by
>> design.

This reminded me of something so I looked it up.
Then I re-read your sample code.

And I think you have asked the wrong question.

The question should be why does fsopen test may_mount?  As it doesn't
mount the filesystem at that point.

Your example code could just do:

int cmd_temp_shm(int argc, char **) {
    if (argc !=3D 1) {
        fprintf(stderr, "Usage: lktool temp_shm\n");
        return 1;
    }

    try {
        OwnedFd context{static_cast<int>(syscall(SYS_fsopen, "tmpfs",
FSOPEN_CLOEXEC))};
        Check(context.fd, "fsopen tmpfs");
        Check(syscall(SYS_fsconfig, context.fd, FSCONFIG_CMD_CREATE,
nullptr, nullptr, 0),
              "fsconfig create tmpfs");

        OwnedFd mount{static_cast<int>(syscall(SYS_fsmount,
context.fd, FSMOUNT_CLOEXEC, 0))};
        Check(mount.fd, "fsmount tmpfs");
        Check(fchdir(mount.fd), "fchdir tmpfs");

        // The detached mount is kept alive by cwd and the mount descriptor.
        // No mount is attached to the inherited filesystem hierarchy.
        std::string path =3D "/proc/" + std::to_string(getpid()) + "/cwd";
        path.push_back('\0');
        WriteAll(STDOUT_FILENO, path);
        for (;;)
            pause();
    } catch (const std::system_error &e) {
        fprintf(stderr, "lktool temp_shm: %s\n", e.what());
        return 1;
    }
}


It would not surprise me if in practice there are assumptions that have
to be worked through to allow that to work, but it seems a perfectly
reasonable thing to do on first glance.  Especially since there are
useful application of doing that.

The really interesting piece to make it through is FSCONFIG_CMD_CREATE.
I think that permission check and the logic there are what needs to
be modified to make it work without a user namespace.

There is also fsopen which has that has a may_mount check that seems
to serve not immediately discernible purpose.

The part that can obviously break pre-existing privileged applications
is the mount_move that attaches the mount to an existing mount
namespace, and that is obviously not allowed.  That definitely can not
be allowed.

The unprivileged mounter without a usernamespace at that point won't
have the ability to reconfigure the filesystem.  So the attack vectors
I was worried about earlier don't seem to apply.

There is a practical question is the additional attack surface and
maintenance burden worth it.

At a quick look it seems reasonable for a handful of filesystems like
tmpfs to allow mounting without first creating a user namespace.

There might even be an argument in there somewhere for allowing
privilege separation of the mount command.

In summary.  At first glance it seems reasonable to allow fsopen,
FSCONFIG_CMD_CREATE, fsmount on select filesystems without privilege and
without a user namespace.

Eric
