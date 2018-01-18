From: Avi Kivity <avi@scylladb.com>
Subject: Re: aio poll, io_pgetevents and a new in-kernel poll API V3
Date: Thu, 18 Jan 2018 19:52:48 +0200
Message-ID: <cc44fc4d-3b4a-581e-9300-15291ab83099@scylladb.com>
References: <20180117192742.710-1-hch@lst.de>
 <x49bmhruq3k.fsf@segfault.boston.devel.redhat.com>
 <7f66bc5a-e9dd-fe4f-c07a-f3de3882365b@scylladb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <7f66bc5a-e9dd-fe4f-c07a-f3de3882365b@scylladb.com>
Content-Language: en-US
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>, Christoph Hellwig <hch@lst.de>
Cc: viro@zeniv.linux.org.uk, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 01/18/2018 07:51 PM, Avi Kivity wrote:
> On 01/18/2018 05:46 PM, Jeff Moyer wrote:
>> FYI, this kernel has issues.  It will boot up, but I don't have
>> networking, and even rebooting doesn't succeed.  I'm looking into it.
>
> FWIW, I'm running an older version of this patchset on my desktop with 
> no problems so far. 

(A Fedora 27)
