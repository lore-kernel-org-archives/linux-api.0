From: Davidlohr Bueso <dave@stgolabs.net>
Subject: Re: [REVIEW][PATCH 13/11] ipc/smack: Tidy up from the change in type
 of the ipc security hooks
Date: Wed, 28 Mar 2018 16:57:59 -0700
Message-ID: <20180328235759.fmnldverphwzq5rt@linux-n805>
References: <1520875093-18174-1-git-send-email-nagarathnam.muthusamy@oracle.com>
 <87vadzqqq6.fsf@xmission.com>
 <990e88fa-ab50-9645-b031-14e1afbf7ccc@oracle.com>
 <877eqejowd.fsf@xmission.com>
 <3a46a03d-e4dd-59b6-e25f-0020be1b1dc9@oracle.com>
 <87a7v2z2qa.fsf@xmission.com>
 <87vadmobdw.fsf_-_@xmission.com>
 <87y3iikp1y.fsf_-_@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87y3iikp1y.fsf_-_@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linux Containers <containers@lists.linux-foundation.org>, esyr@redhat.com, jannh@google.com, khlebnikov@yandex-team.ru, linux-api@vger.kernel.org, serge.hallyn@ubuntu.com, linux-kernel@vger.kernel.org, prakash.sangappa@oracle.com, linux-security-module@vger.kernel.org, luto@kernel.org, oleg@redhat.com, akpm@linux-foundation.org, Nagarathnam Muthusamy <nagarathnam.muthusamy@oracle.com>, Pavel Emelyanov <xemul@openvz.org>
List-Id: linux-api@vger.kernel.org

On Sat, 24 Mar 2018, Eric W. Biederman wrote:

> /**
>- * smack_of_shm - the smack pointer for the shm
>- * @shp: the object
>+ * smack_of_ipc - the smack pointer for the ipc
>+ * @isp: the object

Nit, but while at it the @isp description does need some love:

"@isp: the pointer for the ipc perm structure"
