From: John Johansen <john.johansen@canonical.com>
Subject: Re: [PATCH V34 00/29] Lockdown as an LSM
Date: Tue, 25 Jun 2019 01:16:49 -0700
Message-ID: <642487e9-f70c-c11b-bc61-ad366096e267@canonical.com>
References: <20190622000358.19895-1-matthewgarrett@google.com>
 <alpine.LRH.2.21.1906250853290.7826@namei.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.21.1906250853290.7826@namei.org>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: James Morris <jmorris@namei.org>, Matthew Garrett <matthewgarrett@google.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Stephen Smalley <sds@tycho.nsa.gov>, Andy Lutomirski <luto@amacapital.net>, Casey Schaufler <casey@schaufler-ca.com>
List-Id: linux-api@vger.kernel.org

On 6/24/19 4:01 PM, James Morris wrote:
> On Fri, 21 Jun 2019, Matthew Garrett wrote:
> 
>> Minor updates over V33 - security_is_locked_down renamed to
>> security_locked_down, return value of security_locked_down is returned
>> in most cases, one unnecessary patch was dropped, couple of minor nits
>> fixed.
> 
> Thanks for the respin.
> 
> We are still not resolved on granularity. Stephen has said he's not sure 
> if a useful policy can be constructed with just confidentiality and 
> integrity settings. I'd be interested to know JJ and Casey's thoughts on 
> lockdown policy flexibility wrt their respective LSMs.
> 
> These are also "all or nothing" choices which may prevent deployment due 
> to a user needing to allow (presumably controlled or mitigated) exceptions 
> to the policy.
> 
> 

I haven't gotten a chance to play with this the way I want to so there is
still a lot of questions regarding its interaction with apparmor and its
policy, but from what I have seen so far it is looking good.

I expect the all or nothing choices may limit its deployments (we really
need to play with this more to say) but we already face similar issues.
There are options we provide at a distro level that we can't turn on by
default, but we do recommend to more security conscious users.

If lockdown was in kernel we would certainly make it available for our
users, we have even had a few people ask about it.
