From: James Morris <jmorris@namei.org>
Subject: Re: [PATCH V34 00/29] Lockdown as an LSM
Date: Tue, 25 Jun 2019 09:01:44 +1000 (AEST)
Message-ID: <alpine.LRH.2.21.1906250853290.7826@namei.org>
References: <20190622000358.19895-1-matthewgarrett@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190622000358.19895-1-matthewgarrett@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <matthewgarrett@google.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Stephen Smalley <sds@tycho.nsa.gov>, Andy Lutomirski <luto@amacapital.net>, John Johansen <john.johansen@canonical.com>, Casey Schaufler <casey@schaufler-ca.com>
List-Id: linux-api@vger.kernel.org

On Fri, 21 Jun 2019, Matthew Garrett wrote:

> Minor updates over V33 - security_is_locked_down renamed to
> security_locked_down, return value of security_locked_down is returned
> in most cases, one unnecessary patch was dropped, couple of minor nits
> fixed.

Thanks for the respin.

We are still not resolved on granularity. Stephen has said he's not sure 
if a useful policy can be constructed with just confidentiality and 
integrity settings. I'd be interested to know JJ and Casey's thoughts on 
lockdown policy flexibility wrt their respective LSMs.

These are also "all or nothing" choices which may prevent deployment due 
to a user needing to allow (presumably controlled or mitigated) exceptions 
to the policy.



-- 
James Morris
<jmorris@namei.org>
