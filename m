From: James Morris <jmorris@namei.org>
Subject: Re: [PATCH V34 00/29] Lockdown as an LSM
Date: Tue, 25 Jun 2019 16:04:15 +1000 (AEST)
Message-ID: <alpine.LRH.2.21.1906251601430.26271@namei.org>
References: <20190622000358.19895-1-matthewgarrett@google.com> <alpine.LRH.2.21.1906250853290.7826@namei.org> <CACdnJut2erF9ZKeJQ+uvWZeEnHh=stmEioi_P36DF9mN5i2RGQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CACdnJut2erF9ZKeJQ+uvWZeEnHh=stmEioi_P36DF9mN5i2RGQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <mjg59@google.com>
Cc: LSM List <linux-security-module@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Stephen Smalley <sds@tycho.nsa.gov>, Andy Lutomirski <luto@amacapital.net>, John Johansen <john.johansen@canonical.com>, Casey Schaufler <casey@schaufler-ca.com>
List-Id: linux-api@vger.kernel.org

On Mon, 24 Jun 2019, Matthew Garrett wrote:

> > We are still not resolved on granularity. Stephen has said he's not sure
> > if a useful policy can be constructed with just confidentiality and
> > integrity settings. I'd be interested to know JJ and Casey's thoughts on
> > lockdown policy flexibility wrt their respective LSMs.
> 
> This implementation provides arbitrary granularity at the LSM level,
> though the lockdown LSM itself only provides two levels. Other LSMs
> can choose an appropriate level of exposure.

Ahh, OK, I only looked at the patchset description and had not looked at 
V33 yet.

This is looking good.


-- 
James Morris
<jmorris@namei.org>
