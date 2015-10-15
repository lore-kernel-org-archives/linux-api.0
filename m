From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [dm-devel] [PATCH 3/6] sd: implement the Persistent Reservation
 API
Date: Thu, 15 Oct 2015 08:30:50 -0700
Message-ID: <561FC6AA.3080508@sandisk.com>
References: <1444911052-9423-1-git-send-email-hch@lst.de>
 <1444911052-9423-4-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1444911052-9423-4-git-send-email-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>, axboe@fb.com
Cc: linux-scsi@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, keith.busch@intel.com, Christoph Hellwig <hch@lst.de>
List-Id: linux-api@vger.kernel.org

On 10/15/2015 05:10 AM, Christoph Hellwig wrote:
> This is a mostly trivial mapping to the PERSISTENT RESERVE IN/OUT
> commands.

Hello Christoph,

Can you explain why this functionality has been added to the sd driver 
instead of the SCSI core ? Aren't persistent reservations a concept that 
applies to all SCSI device types ?

Thanks,

Bart.
