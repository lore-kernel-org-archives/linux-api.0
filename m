From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: selective block polling and preadv2/pwritev2 revisited
Date: Wed, 06 Jan 2016 17:49:21 -0500
Message-ID: <yq1h9iqiary.fsf@sermon.lab.mkp.net>
References: <1450966464-6847-1-git-send-email-hch@lst.de>
	<568A889E.4020204@dev.mellanox.co.il> <20160104163949.GA17409@lst.de>
	<568D4859.4010206@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <568D4859.4010206@dev.mellanox.co.il> (Sagi Grimberg's message of
	"Wed, 6 Jan 2016 19:01:13 +0200")
Sender: linux-fsdevel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: Christoph Hellwig <hch@lst.de>, viro@zeniv.linux.org.uk, axboe@fb.com, milosz@adfin.com, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

>>>>> "Sagi" == Sagi Grimberg <sagig@dev.mellanox.co.il> writes:

>> The idea that was floated aroud a few times was to have a flag where
>> the first half of the vectors would be the data, and the second half
>> the metadata.

Sagi> This means that the user would need to pass iovec entries of 8
Sagi> bytes correct? Seems like a waste for large IOs (sorry for
Sagi> diverging from the subject)

The assumption was that there would be a 1:1 mapping between the number
of data buffers and the metadata ditto. But nothing says that a data
iovec entry is limited in size to a single sector.

The other option to have a single iovec at the end representing the
metadata for all data buffers. I think there are valid use cases for
either approach and we may end up having to support both via a flag.

-- 
Martin K. Petersen	Oracle Linux Engineering
