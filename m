From: Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH V34 00/29] Lockdown as an LSM
Date: Mon, 24 Jun 2019 16:47:30 -0700
Message-ID: <c5898a1e-e5c9-c63d-09d4-65fec0744613@schaufler-ca.com>
References: <20190622000358.19895-1-matthewgarrett@google.com>
 <alpine.LRH.2.21.1906250853290.7826@namei.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.21.1906250853290.7826@namei.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: James Morris <jmorris@namei.org>, Matthew Garrett <matthewgarrett@google.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Stephen Smalley <sds@tycho.nsa.gov>, Andy Lutomirski <luto@amacapital.net>, John Johansen <john.johansen@canonical.com>, casey@schaufler-ca.com
List-Id: linux-api@vger.kernel.org

On 6/24/2019 4:01 PM, James Morris wrote:
> On Fri, 21 Jun 2019, Matthew Garrett wrote:
>
>> Minor updates over V33 - security_is_locked_down renamed to
>> security_locked_down, return value of security_locked_down is returned=

>> in most cases, one unnecessary patch was dropped, couple of minor nits=

>> fixed.
> Thanks for the respin.
>
> We are still not resolved on granularity. Stephen has said he's not sur=
e=20
> if a useful policy can be constructed with just confidentiality and=20
> integrity settings. I'd be interested to know JJ and Casey's thoughts o=
n=20
> lockdown policy flexibility wrt their respective LSMs.

Smack is a mandatory access control mechanism on named
objects controlled by the system. Issues of administrative
control, like whether hibernation is allowed, are outside
the scope of what Smack controls. There may be some subject/object
implications, but I have not identified any yet.

> These are also "all or nothing" choices which may prevent deployment du=
e=20
> to a user needing to allow (presumably controlled or mitigated) excepti=
ons=20
> to the policy.
