From: Matthew Garrett <mjg59@google.com>
Subject: Re: [PATCH V34 00/29] Lockdown as an LSM
Date: Mon, 24 Jun 2019 16:56:25 -0700
Message-ID: <CACdnJut2erF9ZKeJQ+uvWZeEnHh=stmEioi_P36DF9mN5i2RGQ@mail.gmail.com>
References: <20190622000358.19895-1-matthewgarrett@google.com> <alpine.LRH.2.21.1906250853290.7826@namei.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.21.1906250853290.7826@namei.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James Morris <jmorris@namei.org>
Cc: LSM List <linux-security-module@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Stephen Smalley <sds@tycho.nsa.gov>, Andy Lutomirski <luto@amacapital.net>, John Johansen <john.johansen@canonical.com>, Casey Schaufler <casey@schaufler-ca.com>
List-Id: linux-api@vger.kernel.org

On Mon, Jun 24, 2019 at 4:01 PM James Morris <jmorris@namei.org> wrote:
>
> On Fri, 21 Jun 2019, Matthew Garrett wrote:
>
> > Minor updates over V33 - security_is_locked_down renamed to
> > security_locked_down, return value of security_locked_down is returned
> > in most cases, one unnecessary patch was dropped, couple of minor nits
> > fixed.
>
> Thanks for the respin.
>
> We are still not resolved on granularity. Stephen has said he's not sure
> if a useful policy can be constructed with just confidentiality and
> integrity settings. I'd be interested to know JJ and Casey's thoughts on
> lockdown policy flexibility wrt their respective LSMs.

This implementation provides arbitrary granularity at the LSM level,
though the lockdown LSM itself only provides two levels. Other LSMs
can choose an appropriate level of exposure.

> These are also "all or nothing" choices which may prevent deployment due
> to a user needing to allow (presumably controlled or mitigated) exceptions
> to the policy.

Distributions have been deploying the "all or nothing" solution for
several years now, which implies that it's adequate for the common
case. I think it's reasonable to punt finer grained policies over to
other LSMs - people who want that are probably already using custom
LSM policy.
