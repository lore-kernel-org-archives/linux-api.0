Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=166.70.13.231
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793936904;
	b=fnckPFiyqc+cqFSJQHEpleeuMep2J8mhPtIVbjwBK+QjLZiybRMf9QYxM0Ft9WlAMe2c
	 ePGgCrrt7KIXrdR84JKx2fC5uySdM8Uqn85EVkH7ijdj/3qDwJH5c6R6i1JMC/KSRgBhP
	 hMdeaj1t2PQaD/J4HSx+X0D2pB4+ccayAqqWWrpme075XP6lVh6gTchsypYkGcZrdce7Y
	 67Sv+Gg5vn6yTM4cBwue/JOvKnuaYbknbJCWWE6l+/UfJ8+QIpJsjV68/8thPM4wPBEOF
	 qQR8eDPA92YMEt981TNdLHi1Y/jpkAvQBHXoo7Ayw/ERV4XblI5sinkYCrw0JiAYJDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793936904;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:In-Reply-To:
	 References:Date:Message-ID:User-Agent:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-XM-SPF:X-XM-AID:X-Spam-Checker-Version:
	 X-Spam-Level:X-Spam-Status:X-Spam-Virus:X-Spam-Report:X-Spam-DCC:
	 X-Spam-Combo:X-Spam-Relay-Country:X-Spam-Timing:Subject:
	 X-SA-Exim-Connect-IP:X-SA-Exim-Rcpt-To:X-SA-Exim-Mail-From:
	 X-SA-Exim-Scanned;
	bh=Be0Za5xRQuKpCLQH+AxKFL6WKlTHgvlPTNvTbJmkg0A=;
	b=4aO6EdiF6nPeBGxspzY8VfgmH9tC2wVOEsTfHSqYwMC8a64qv9yuV/30sxztd0oQHcuJ
	 r2chYmJ0PBXTxaGLe/hF520QGG4UdG8WRRGP/Icjkilh8x8nAY5ndAv2yuomqaMkltWpQ
	 RYoKVT43iZON9D8TMx8UTy5MVHICA6i+6vWT+Jrc3O1V9buTAeABZOdmfzT5EMAhpt5Ma
	 ZdwMtrqKLL6Kbf1TgeWKYnMJcB6NA2T+IB0fc75rZY8BeC51XNZy5AJKcZFFCZEz66IZE
	 O0MpEZKMkqEDV1+5ukRVSF9gukP3qwN2z0Slq+4806LKR+pJ6CJHBXQ+DdkJZlRGR9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=xmission.com;
	spf=pass smtp.mailfrom=xmission.com;
	dkim=pass header.d=xmission.com header.i=@xmission.com header.a=rsa-sha256 header.s=xmission header.b=EHKXlCPs;
	arc=none smtp.remote-ip=166.70.13.231
Received: from out01.mta.xmission.com (out01.mta.xmission.com [166.70.13.231])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99C71606A31B;
	Fri,  6 Nov 2026 03:48:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 99C71606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=xmission.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xmission.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=xmission.com header.i=@xmission.com header.a=rsa-sha256 header.s=xmission header.b=EHKXlCPs
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=simple/simple; d=xmission.com;
	 s=xmission; h=Subject:Content-Transfer-Encoding:Content-Type:MIME-Version:
	Message-ID:Date:References:In-Reply-To:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=qOycUJnM4+Vyffpl3FVfBzrNIrruMMWTqnYgMXkrk38=; b=EHKXlCPszM0rpYy4cajgqFYg4J
	jWoICZTCzQtAO63laxuT/FUZ1ri1EN9NyXmJc6p+GeBT305E//7uGH+jtyE0EUH2J0oAw7H3WR7yP
	mUiTG+oP/HJsngXtPE2Uj13DfHhZgTyJ5ZkW41lesRVQMThtz2M7RWSnaVp2hQzqlfiU=;
Received: from in02.mta.xmission.com ([166.70.13.52]:44172)
	by out01.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.93)
	(envelope-from <ebiederm@xmission.com>)
	id 1xPAw4-000kR9-NM; Thu, 05 Nov 2026 20:48:16 -0700
Received: from ip72-198-196-98.om.om.cox.net ([72.198.196.98]:60968 helo=email.froward.int.ebiederm.org.xmission.com)
	by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.93)
	(envelope-from <ebiederm@xmission.com>)
	id 1xPAw3-00Cpbz-Ft; Thu, 05 Nov 2026 20:48:16 -0700
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>,  Linux API
 <linux-api@vger.kernel.org>
In-Reply-To: <CALCETrXnZVq4pcmo=2T2S=yzWuj9Q5tvrpuZTXzU4ptHCDnjBA@mail.gmail.com>
	(Andy Lutomirski's message of "Tue, 3 Nov 2026 20:02:12 -0800")
References: <CALCETrWDJKr=LMzfPjwwRRuKapFKQ_OaYF6qYz-9Cs91xAXUgA@mail.gmail.com>
	<87se1hclmb.fsf@email.froward.int.ebiederm.org>
	<CALCETrXnZVq4pcmo=2T2S=yzWuj9Q5tvrpuZTXzU4ptHCDnjBA@mail.gmail.com>
Date: Thu, 05 Nov 2026 21:48:11 -0600
Message-ID: <87bj82d3ic.fsf@email.froward.int.ebiederm.org>
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
X-XM-SPF: eid=1xPAw3-00Cpbz-Ft;;;mid=<87bj82d3ic.fsf@email.froward.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=72.198.196.98;;;frm=ebiederm@xmission.com;;;sPfnum=0;;;sPf=pass
X-XM-AID: U2FsdGVkX19xw+2xzokroOVsQV1/cg6Q/Fo7dzZ0siU=
X-Spam-Level: 
X-Spam-Virus: No
X-Spam-Report: 
	* -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.0 XM_B_Unicode BODY: Testing for specific types of unicode
	*  0.0 XM_B_EmailChain RAW: Email Chain Detected
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.2 XM_B_SpammyWords One or more commonly used spammy words
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andy Lutomirski <luto@amacapital.net>
X-Spam-Relay-Country: 
X-Spam-Timing: total 738 ms - load_scoreonly_sql: 0.04 (0.0%),
	signal_user_changed: 4.4 (0.6%), b_tie_ro: 3.0 (0.4%), parse: 1.67
	(0.2%), extract_message_metadata: 16 (2.2%), get_uri_detail_list: 2.9
	(0.4%), tests_pri_-2000: 15 (2.0%), tests_pri_-1000: 1.95 (0.3%),
	tests_pri_-950: 1.01 (0.1%), tests_pri_-900: 0.69 (0.1%),
	tests_pri_-90: 64 (8.7%), check_bayes: 63 (8.6%), b_tokenize: 10
	(1.3%), b_tok_get_all: 11 (1.5%), b_comp_prob: 3.5 (0.5%),
	b_tok_touch_all: 34 (4.6%), b_finish: 0.88 (0.1%), tests_pri_0: 550
	(74.5%), check_dkim_signature: 0.53 (0.1%), check_dkim_adsp: 2.1
	(0.3%), poll_dns_idle: 69 (9.3%), tests_pri_10: 1.72 (0.2%),
	tests_pri_500: 78 (10.6%), rewrite_mail: 0.00 (0.0%)
Subject: Re: Accidental mountns/tmpfs API break from 2016?
X-SA-Exim-Connect-IP: 166.70.13.52
X-SA-Exim-Rcpt-To: linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, luto@amacapital.net
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on out01.mta.xmission.com); SAEximRunCond expanded to false

Andy Lutomirski <luto@amacapital.net> writes:

 On Tue, Nov 3, 2026 at 7:37=E2=80=AFPM Eric W. Biederman <ebiederm@xmissio=
n.com> wrote:
>>
>> Andy Lutomirski <luto@amacapital.net> writes:
>>
>> > Hi-
>> >
>> > I (well, an LLM following my rather explicit instructions) just wrote
>> > a little tool to make a tmpfs as an unprivileged user: it unshares
>> > userns and mountns, makes a tmpfs, fchdirs to it, and prints
>> > /proc/PID/cwd to stdout.  Full source below.
>> >
>> > I was a bit surprised that trying to create anything in the tmpfs did
>> > not work without a uid_map and gid_map.  It looks like it came from:
>> >
>> > commit 036d523641c66bef713042894a17f4335f199e49
>> > Author: Eric W. Biederman <ebiederm@xmission.com>
>> > Date:   Fri Jul 1 12:52:06 2016 -0500
>> >
>> >     vfs: Don't create inodes with a uid or gid unknown to the vfs
>> >
>> >     It is expected that filesystems can not represent uids and gids fr=
om
>> >     outside of their user namespace.  Keep things simple by not even
>> >     trying to create filesystem nodes with non-sense uids and gids.
>> >
>> >     Acked-by: Seth Forshee <seth.forshee@canonical.com>
>> >     Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
>> >
>> >
>> > Now my tool won't actually run on a pre-2016 kernel due to use of
>> > fsopen, and I'm not about to say that a decade-old commit broke my ABI
>> > and needs to be reverted.  But I am rather curious whether this rule
>> > actually makes sense.
>>
>> I am pretty certain it was deliberate at the time.
>>
>> > I'm not creating an idmapped mount, and I'm
>> > using tmpfs, which could not care less about the mapping as far as I
>> > know.
>> >
>> > Would it make sense to only enforce this for filesystems that care?
>>
>> Interesting question.  You are in a user namespace.  You are
>> running as a user that does not exist in your user namespace.
>> You want to create files.
>>
>> You can map a that single uid and gid without privileges.
>> So there is no hardship in getting a uid and gid in your user namespace.
>>
>> Is it just the extra bit of code to perform that write that is the
>> problem?
>>
>> Why would you want to be able to create files as a owned by a user
>> from another user namespace?  Even if you created them reading them
>> would show an 0xfffe the invalid uid/gid.  I think there are then
>> some difficulties in using those files as well.
>>
>> Why would you want to do much of anything as without having a
>> properly setup uid or gid?
>
> Hah, you haven't quite figured out the ridiculous thing I'm doing. :)
> What I want is a temporary tmpfs that I can create as an unprivileged
> user.  Linux doesn't let me do that directly, so I'm kludging it.
> Shell transcript, edited for clarity:
>
> #### Make a tmpfs, keeping the tool running to keep it alive
> $ ./temp_shm &
> [1] 34157
> /proc/34157/cwd
>
> #### cd to the tmpfs, which references it and keeps it alive
> $ cd /proc/34157/cwd
>
> #### Kill the tool, since we're done with it
> $ fg
> bin/lktool temp_shm     (wd: /workspaces/master)
> ^C
>
> #### cwd is a working tmpfs!
> $ echo "Look a tmpfs!" >some_file
>
> #### and it has no '..', as expected :)
> $ cd ..                  # and it has
> cd: error retrieving current directory: getcwd: cannot access parent
> directories: No such file or directory
>
> This whole workflow runs in the init userns and the init mountns,
> which is exactly what I wanted.  And now I have a tmpfs that I can use
> to run my test suite unprivileged to test some cool code that *needs*
> a tmpfs.  (Yes, I could probably use /dev/shm, but that's messy and I
> don't want to.)
>
> I'm not actually banging this out in shell, but I am running literally
> the C++ code I posted as a subprocess called by my test harness.
>
> The user creating files is not in the mountns or the userns, by design.
>
>>
>> At a quick look tmpfs just uses vfs inodes which use kuid_t and kgid_t
>> so it theoretically would be ok.
>>
>> Still what would be the motivation for supporting something so silly?
>>
>
> My test suite! :)
>
>> If there is a good use case I could see it making sense to support it.
>
> I think my use case is excellent.
>
> Seriously, though, I think a *much* nicer solution would be to allow
> fsconfig and fsmount to be called by an unprivileged user, at least
> for some very limited list of filesystems.
>
>>
>> Short of a good use case we are talking about having to support weird
>> corner cases that no one really cares about that will just bit-rot.
>>
>> Note.  You can identity map your original uid and gid, instead of
>> mapping your uid and gid 0.
>
> Does the inner uid made a sound if there's no running task to observe
> it? :)

Hmm.  So the problem is that the user outside of the user namespace
can't write files unless he is mapped.

I think I even remember why that happened originally, it seems very
familiar.

I think that was to prevent processes running inside of a user namespace
from having to deal with files and directories appearing on their
filesystem that their isn't full information for because they aren't
mapped.

In particular I think it prevents "chmod u+S file" on a file that isn't
mapped into the user namespace.

The issue is that the mounter of the filesystem has all caps over the
filesystem.

So in general you don't want them to be able to manipulate files that
they couldn't create.

Eric
