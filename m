From: Davidlohr Bueso <dave@stgolabs.net>
Subject: Re: [REVIEW][PATCH 13/11] ipc/smack: Tidy up from the change in type
 of the ipc security hooks
Date: Wed, 28 Mar 2018 16:38:34 -0700
Message-ID: <20180328233834.ceh4xuhiyjnxonic@linux-n805>
References: <1520875093-18174-1-git-send-email-nagarathnam.muthusamy@oracle.com>
 <87vadzqqq6.fsf@xmission.com>
 <990e88fa-ab50-9645-b031-14e1afbf7ccc@oracle.com>
 <877eqejowd.fsf@xmission.com>
 <3a46a03d-e4dd-59b6-e25f-0020be1b1dc9@oracle.com>
 <87a7v2z2qa.fsf@xmission.com>
 <87vadmobdw.fsf_-_@xmission.com>
 <87y3iikp1y.fsf_-_@xmission.com>
 <80cd2fea-c9a8-4f26-acbb-e0ecb34e4e40@schaufler-ca.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <80cd2fea-c9a8-4f26-acbb-e0ecb34e4e40@schaufler-ca.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Linux Containers <containers@lists.linux-foundation.org>, esyr@redhat.com, jannh@google.com, khlebnikov@yandex-team.ru, linux-api@vger.kernel.org, serge.hallyn@ubuntu.com, linux-kernel@vger.kernel.org, prakash.sangappa@oracle.com, linux-security-module@vger.kernel.org, luto@kernel.org, oleg@redhat.com, akpm@linux-foundation.org, Nagarathnam Muthusamy <nagarathnam.muthusamy@oracle.com>, Pavel Emelyanov <xemul@openvz.org>, Paul Moore <paul@paul-moore.com>
List-Id: linux-api@vger.kernel.org

On Sat, 24 Mar 2018, Casey Schaufler wrote:

>On 3/23/2018 10:42 PM, Eric W. Biederman wrote:
>> Rename the variables shp, sma, msq to isp. As that is how the code already
>> refers to those variables.
>
>Thanks. It's important to keep the code readable.

Ah great, ignore my last email then.
