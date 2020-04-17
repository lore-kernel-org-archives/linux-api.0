Return-Path: <SRS0=XBkQ=6B=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF319C2BB1D
	for <linux-api@archiver.kernel.org>; Fri, 17 Apr 2020 22:26:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C69F20776
	for <linux-api@archiver.kernel.org>; Fri, 17 Apr 2020 22:26:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728644AbgDQW0S (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Fri, 17 Apr 2020 18:26:18 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:51506 "EHLO
        out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728470AbgDQW0R (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Fri, 17 Apr 2020 18:26:17 -0400
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out02.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <ebiederm@xmission.com>)
        id 1jPZR5-0003bo-Sg; Fri, 17 Apr 2020 16:26:12 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1jPZR4-0002qC-5z; Fri, 17 Apr 2020 16:26:11 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Paul Moore <paul@paul-moore.com>
Cc:     Richard Guy Briggs <rgb@redhat.com>, nhorman@tuxdriver.com,
        linux-api@vger.kernel.org, containers@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>, dhowells@redhat.com,
        linux-audit@redhat.com, netfilter-devel@vger.kernel.org,
        simo@redhat.com, netdev@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Eric Paris <eparis@parisplace.org>,
        mpatel@redhat.com, Serge Hallyn <serge@hallyn.com>
References: <20200318215550.es4stkjwnefrfen2@madcap2.tricolour.ca>
        <CAHC9VhSdDDP7Ec-w61NhGxZG5ZiekmrBCAg=Y=VJvEZcgQh46g@mail.gmail.com>
        <20200319220249.jyr6xmwvflya5mks@madcap2.tricolour.ca>
        <CAHC9VhR84aN72yNB_j61zZgrQV1y6yvrBLNY7jp7BqQiEDL+cw@mail.gmail.com>
        <20200324210152.5uydf3zqi3dwshfu@madcap2.tricolour.ca>
        <CAHC9VhTQUnVhoN3JXTAQ7ti+nNLfGNVXhT6D-GYJRSpJHCwDRg@mail.gmail.com>
        <20200330134705.jlrkoiqpgjh3rvoh@madcap2.tricolour.ca>
        <CAHC9VhQTsEMcYAF1CSHrrVn07DR450W9j6sFVfKAQZ0VpheOfw@mail.gmail.com>
        <20200330162156.mzh2tsnovngudlx2@madcap2.tricolour.ca>
        <CAHC9VhTRzZXJ6yUFL+xZWHNWZFTyiizBK12ntrcSwmgmySbkWw@mail.gmail.com>
        <20200330174937.xalrsiev7q3yxsx2@madcap2.tricolour.ca>
        <CAHC9VhR_bKSHDn2WAUgkquu+COwZUanc0RV3GRjMDvpoJ5krjQ@mail.gmail.com>
        <871ronf9x2.fsf@x220.int.ebiederm.org>
        <CAHC9VhR3gbmj5+5MY-whLtStKqDEHgvMRigU9hW0X1kpxF91ag@mail.gmail.com>
Date:   Fri, 17 Apr 2020 17:23:08 -0500
In-Reply-To: <CAHC9VhR3gbmj5+5MY-whLtStKqDEHgvMRigU9hW0X1kpxF91ag@mail.gmail.com>
        (Paul Moore's message of "Thu, 16 Apr 2020 17:53:23 -0400")
Message-ID: <871rol7nw3.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1jPZR4-0002qC-5z;;;mid=<871rol7nw3.fsf@x220.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19qZeMGpaRFmwABWE5nM2gXLxe0XB+DPDY=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH ghak90 V8 07/16] audit: add contid support for signalling the audit daemon
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Paul Moore <paul@paul-moore.com> writes:

> On Thu, Apr 16, 2020 at 4:36 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
>> Paul Moore <paul@paul-moore.com> writes:
>> > On Mon, Mar 30, 2020 at 1:49 PM Richard Guy Briggs <rgb@redhat.com> wrote:
>> >> On 2020-03-30 13:34, Paul Moore wrote:
>> >> > On Mon, Mar 30, 2020 at 12:22 PM Richard Guy Briggs <rgb@redhat.com> wrote:
>> >> > > On 2020-03-30 10:26, Paul Moore wrote:
>> >> > > > On Mon, Mar 30, 2020 at 9:47 AM Richard Guy Briggs <rgb@redhat.com> wrote:
>> >> > > > > On 2020-03-28 23:11, Paul Moore wrote:
>> >> > > > > > On Tue, Mar 24, 2020 at 5:02 PM Richard Guy Briggs <rgb@redhat.com> wrote:
>> >> > > > > > > On 2020-03-23 20:16, Paul Moore wrote:
>> >> > > > > > > > On Thu, Mar 19, 2020 at 6:03 PM Richard Guy Briggs <rgb@redhat.com> wrote:
>> >> > > > > > > > > On 2020-03-18 18:06, Paul Moore wrote:
>> >
>> > ...
>> >
>> >> > > Well, every time a record gets generated, *any* record gets generated,
>> >> > > we'll need to check for which audit daemons this record is in scope and
>> >> > > generate a different one for each depending on the content and whether
>> >> > > or not the content is influenced by the scope.
>> >> >
>> >> > That's the problem right there - we don't want to have to generate a
>> >> > unique record for *each* auditd on *every* record.  That is a recipe
>> >> > for disaster.
>> >> >
>> >> > Solving this for all of the known audit records is not something we
>> >> > need to worry about in depth at the moment (although giving it some
>> >> > casual thought is not a bad thing), but solving this for the audit
>> >> > container ID information *is* something we need to worry about right
>> >> > now.
>> >>
>> >> If you think that a different nested contid value string per daemon is
>> >> not acceptable, then we are back to issuing a record that has only *one*
>> >> contid listed without any nesting information.  This brings us back to
>> >> the original problem of keeping *all* audit log history since the boot
>> >> of the machine to be able to track the nesting of any particular contid.
>> >
>> > I'm not ruling anything out, except for the "let's just completely
>> > regenerate every record for each auditd instance".
>>
>> Paul I am a bit confused about what you are referring to when you say
>> regenerate every record.
>>
>> Are you saying that you don't want to repeat the sequence:
>>         audit_log_start(...);
>>         audit_log_format(...);
>>         audit_log_end(...);
>> for every nested audit daemon?
>
> If it can be avoided yes.  Audit performance is already not-awesome,
> this would make it even worse.

As far as I can see not repeating sequences like that is fundamental
for making this work at all.  Just because only the audit subsystem
should know about one or multiple audit daemons.  Nothing else should
care.

>> Or are you saying that you would like to literraly want to send the same
>> skb to each of the nested audit daemons?
>
> Ideally we would reuse the generated audit messages as much as
> possible.  Less work is better.  That's really my main concern here,
> let's make sure we aren't going to totally tank performance when we
> have a bunch of nested audit daemons.

So I think there are two parts of this answer.  Assuming we are talking
about nesting audit daemons in containers we will have different
rulesets and I expect most of the events for a nested audit daemon won't
be of interest to the outer audit daemon.

Beyond that it should be very straight forward to keep a pointer and
leave the buffer as a scatter gather list until audit_log_end
and translate pids, and rewrite ACIDs attributes in audit_log_end
when we build the final packet.  Either through collaboration with
audit_log_format or a special audit_log command that carefully sets
up the handful of things that need that information.

Hmm.  I am seeing that we send skbs to kauditd and then kauditd
sends those skbs to userspace.  I presume that is primary so that
sending messages to userspace does not block the process being audited.

Plus a little bit so that the retry logic will work.

I think the naive implementation would be to simply have 1 kauditd
per auditd (strictly and audit context/namespace).  Although that can be
optimized if that is a problem.

Beyond that I think we would need to look at profiles to really
understand where the bottlenecks are.

>> Or are you thinking of something else?
>
> As mentioned above, I'm not thinking of anything specific, other than
> let's please not have to regenerate *all* of the audit record strings
> for each instance of an audit daemon, that's going to be a killer.
>
> Maybe we have to regenerate some, if we do, what would that look like
> in code?  How do we handle the regeneration aspect?  I worry that is
> going to be really ugly.
>
> Maybe we finally burn down the audit_log_format(...) function and pass
> structs/TLVs to the audit subsystem and the audit subsystem generates
> the strings in the auditd connection thread.  Some of the record
> strings could likely be shared, others would need to be ACID/auditd
> dependent.

I think we just a very limited amount of structs/TLVs for the cases that
matter and one-one auditd and kauditd implementations we should still
be able to do everything in audit_log_end.  Plus doing as much work as
possible in audit_log_end where things are still cache hot is desirable.

> I'm open to any ideas people may have.  We have a problem, let's solve
> it.

It definitely makes sense to look ahead to having audit daemons running
in containers, but in the grand scheme of things that is a nice to have.
Probably something we will and should get to, but we have lived a long
time without auditd running in containers so I expect we can live a
while longer.

As I understand Richard patchset for the specific case of the ACID we
are only talking about taking a subset of an existing string, and one
string at that.  Not hard at all.  Especially when looking at the
fundamental fact that we will need to send a different skb to
userspace, for each audit daemon.

Eric
