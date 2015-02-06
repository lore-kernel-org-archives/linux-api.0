From: "Seymour, Shane M" <shane.seymour@hp.com>
Subject: [RFC] implementing tape statistics single file vs multi-file in
 sysfs
Date: Fri, 6 Feb 2015 00:20:53 +0000
Message-ID: <DDB9C85B850785449757F9914A034FCB3BF3EADA@G9W0766.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
To: "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "Kai.Makisara@kolumbus.fi" <Kai.Makisara@kolumbus.fi>, "James E.J. Bottomley (JBottomley@parallels.com)" <JBottomley@parallels.com>, "Laurence Oberman (loberman@redhat.com)" <loberman@redhat.com>
List-Id: linux-api@vger.kernel.org

Hello linux-api'ers

There has been some ongoing discussion about the best way to implement tape statistics. The original method suggested a long time ago used a single file in sysfs similar to block statistics in sysfs. That lead to an impass about the code on the linux-scsi mailing list.

The sysfs documentation says that files should contain one item per file (with some small exceptions):

> "Attributes should be ASCII text files, preferably with only one value
> per file. It is noted that it may not be efficient to contain only one
> value per file, so it is socially acceptable to express an array of
> values of the same type."

The current patch that implements tape statistics is here:

http://marc.info/?l=linux-scsi&m=142112067313723&w=2

Recently there was was another discussion here about one file vs a collection of files for tape statistics:

http://marc.info/?l=linux-scsi&m=142316255501550&w=2

The result was that I should ask here what method I should use. I would like to get feedback in relation to tape statistics and one file vs multi-file in sysfs. I'm happy to keep the existing code or change to a single file approach.

Thanks
Shane
