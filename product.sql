GO

/****** Object:  Table [dbo].[base1]    Script Date: 2018/12/2 星期日 下午 11:10:22 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
--创建存储普通牌A-K的可能组合的表base1
CREATE TABLE [dbo].[base1](
	[player1] [decimal](18, 0) NULL,
	[player2] [decimal](18, 0) NULL,
	[player3] [decimal](18, 0) NULL,
	[allCount] [decimal](18, 0) NULL
) ON [PRIMARY]

GO

GO
--插入普通4张相同牌--例如4个3在每个玩家手中的可能组合。
INSERT INTO [dbo].[base1]
           ([player1]
           ,[player2]
           ,[player3]
           ,[allCount])
     VALUES
           (4,0,0,4),
		   (0,4,0,4),
		   (0,0,4,4),
		   (3,0,1,4),
		   (3,1,0,4),
		   (0,1,3,4),
		   (0,3,1,4),
		   (1,0,3,4),
		   (1,3,0,4),
		   (2,2,0,4),
		   (2,0,2,4),
		   (2,1,1,4),
		   (1,1,2,4),
		   (1,2,1,4),
		   (0,2,2,4);
GO

GO

/****** Object:  Table [dbo].[base2]    Script Date: 2018/12/2 星期日 下午 11:10:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--存储大小王可能组合的表base2
CREATE TABLE [dbo].[base2](
	[player1] [decimal](18, 0) NULL,
	[player2] [decimal](18, 0) NULL,
	[player3] [decimal](18, 0) NULL,
	[allCount] [decimal](18, 0) NULL
) ON [PRIMARY]

GO


GO

GO
--插入大王或者小王在每个玩家手中的组合情况。
INSERT INTO [dbo].[base2]
           ([player1]
           ,[player2]
           ,[player3]
           ,[allCount])
     VALUES
           (0,0,1,1),
		   (0,1,0,1),
		   (1,0,0,1);
GO

--将手牌3~7 的所有可能组合存储于cardgroup1,默认地主是player1。
--条件2的意思就是4个3，4，5，6，7加起来20张牌不可能全部都在玩家二(player2)手中
  select IDENTITY(int, 1,1) AS id,a1.player1+a2.player1+a3.player1+a4.player1+a5.player1 as player1,
  a1.player2+a2.player2+a3.player2+a4.player2+a5.player2 as player2,
  a1.player3+a2.player3+a3.player3+a4.player3+a5.player3 as player3,
  (a1.allcount+a2.allcount+a3.allcount+a4.allcount+a5.allcount
  ) as allcount
  into cardgroup1
  from base1 a1,base1 a2,base1 a3,base1 a4,base1 a5 
  where a1.player1+a2.player1+a3.player1+a4.player1+a5.player1<=20
 and a1.player2+a2.player2+a3.player2+a4.player2+a5.player2<=17
 and a1.player3+a2.player3+a3.player3+a4.player3+a5.player3<=17

--将手牌8~Q 的所有可能组合存储于cardgroup2
  select IDENTITY(int, 1,1) AS id,a1.player1+a2.player1+a3.player1+a4.player1+a5.player1 as player1,
  a1.player2+a2.player2+a3.player2+a4.player2+a5.player2 as player2,
  a1.player3+a2.player3+a3.player3+a4.player3+a5.player3 as player3,
  (a1.allcount+a2.allcount+a3.allcount+a4.allcount+a5.allcount
  ) as allcount
  into cardgroup2
  from base1 a1,base1 a2,base1 a3,base1 a4,base1 a5
  where a1.player1+a2.player1+a3.player1+a4.player1+a5.player1<=20
 and a1.player2+a2.player2+a3.player2+a4.player2+a5.player2<=17
 and a1.player3+a2.player3+a3.player3+a4.player3+a5.player3<=17

 --将手牌K,A,2,小王,大王 的所有可能组合存储于cardgroup3
  select IDENTITY(int, 1,1) AS id,a1.player1+a2.player1+a3.player1+a4.player1+a5.player1 as player1,
  a1.player2+a2.player2+a3.player2+a4.player2+a5.player2 as player2,
  a1.player3+a2.player3+a3.player3+a4.player3+a5.player3 as player3,
  (a1.allcount+a2.allcount+a3.allcount+a4.allcount+a5.allcount
  ) as allcount
  into cardgroup3
  from base1 a1,base1 a2,base1 a3,base2 a4,base2 a5
  where a1.player1+a2.player1+a3.player1+a4.player1+a5.player1<=20
 and a1.player2+a2.player2+a3.player2+a4.player2+a5.player2<=17
 and a1.player3+a2.player3+a3.player3+a4.player3+a5.player3<=17

 --分别获取每个分组中,手牌数相同的牌型组合
select distinct  player1, player2,player3 into distinctgroup1 from cardgroup1
select distinct  player1, player2,player3 into distinctgroup2 from cardgroup2
select distinct  player1, player2,player3 into distinctgroup3 from cardgroup3

--构建结果表
select
IDENTITY(int, 1,1) AS id,
distinctgroup1.player1 group1_player1,
distinctgroup1.player2 group1_player2,
distinctgroup1.player3 group1_player3,
distinctgroup2.player1 group2_player1,
distinctgroup2.player2 group2_player2,
distinctgroup2.player3 group2_player3,
distinctgroup3.player1 group3_player1,
distinctgroup3.player2 group3_player2,
distinctgroup3.player3 group3_player3,
cast(0 as decimal) as group1Count,
cast(0 as decimal) as group2Count,
cast(0 as decimal) as group3Count,
cast(0 as decimal) as product
into result
from distinctgroup1,distinctgroup2,distinctgroup3
where distinctgroup1.player1+distinctgroup2.player1+distinctgroup3.player1=20
and distinctgroup1.player2+distinctgroup2.player2+distinctgroup3.player2=17
and distinctgroup1.player3+distinctgroup2.player3+distinctgroup3.player3=17

--更新结果表的因子列
update result set group1Count= (select count(1) from cardgroup1  where group1_player1=player1 and group1_player2=player2 and group1_player3=player3),
                  group2Count= (select count(1) from cardgroup2  where group2_player1=player1 and group2_player2=player2 and group2_player3=player3),
				  group3Count= (select count(1) from cardgroup3  where group3_player1=player1 and group3_player2=player2 and group3_player3=player3);
--更新每种组合的积	
update result set	  product=group1Count*group2Count*group3Count
--计算出最终结果
select sum(product) as 总组合数 from result
